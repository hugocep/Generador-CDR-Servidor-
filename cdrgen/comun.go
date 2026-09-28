package main

// Funciones compartidas por voz y SMS. Replican la logica de los scripts corregidos
// (servidor/new_voz_nacional_campos.sh y servidor/new_sms_nacional_campos.sh).

import (
	"errors"
	"fmt"
	"math/rand/v2"
	"regexp"
	"strconv"
	"strings"
	"time"
)

// VLR de Telcel que usan los scripts cuando no hay roaming.
const vlrTelcel = "5294100000980"

type Gen struct {
	base   string // carpeta que contiene datos/ y CDR/
	rnd    *rand.Rand
	ahora  func() time.Time
	log    strings.Builder
	avisos []string

	hd     []string // datos/headers.txt
	nh     []string // datos/new_headers.txt
	grupos []string // datos/origen_nacional_destino_internacional.txt
}

type Resultado struct {
	Tipo      string   `json:"tipo"`
	Params    []string `json:"params"`
	Archivos  []string `json:"archivos"`
	Lineas    []string `json:"lineas"`
	Contenido []string `json:"contenido"` // archivo Content_SRS (solo voz por cobrar)
	Log       string   `json:"log"`
	Avisos    []string `json:"avisos"`
	Error     string   `json:"error"`
}

// errSalida equivale a los "----EXIT----" de los scripts.
type errSalida struct{ msg string }

func (e *errSalida) Error() string { return e.msg }

func salida(msg string) error { return &errSalida{msg} }

func esSalida(err error) bool {
	var e *errSalida
	return errors.As(err, &e)
}

func nuevoGen(base string) *Gen {
	return &Gen{
		base:  base,
		rnd:   rand.New(rand.NewPCG(uint64(time.Now().UnixNano()), 0x5eed)),
		ahora: time.Now,
	}
}

func (g *Gen) logf(format string, args ...any) {
	fmt.Fprintf(&g.log, format+"\n", args...)
}

func (g *Gen) aviso(s string) {
	g.avisos = append(g.avisos, s)
	g.logf("AVISO: %s", s)
}

// param regresa el parametro posicional n (1 = $1), vacio si no se paso.
func param(p []string, n int) string {
	if n-1 < len(p) {
		return p[n-1]
	}
	return ""
}

// ---------------------------------------------------------------- validaciones

var (
	reFecha   = regexp.MustCompile(`^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$`)
	reTiempo  = regexp.MustCompile(`^[0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2}$`)
	reDigitos = regexp.MustCompile(`^[0-9]+$`)
	reNumA    = regexp.MustCompile(`^[0-9]{10}$`)
	reIMSI    = regexp.MustCompile(`^[0-9]{15}$`)
	reCDRs    = regexp.MustCompile(`^[0-9]{1,6}$`)
)

func atoi(s string) int { n, _ := strconv.Atoi(s); return n }

// validaFecha: DD/MM/YYYY, año entre 1990 y el año actual + 1, y que exista en el calendario.
func (g *Gen) validaFecha(s string) bool {
	if !reFecha.MatchString(s) {
		return false
	}
	p := strings.Split(s, "/")
	d, m, a := atoi(p[0]), atoi(p[1]), atoi(p[2])
	if a > g.ahora().Year()+1 || a < 1990 || m < 1 || m > 12 || d < 1 {
		return false
	}
	return d <= time.Date(a, time.Month(m)+1, 0, 0, 0, 0, 0, time.UTC).Day()
}

func validaTiempo(s string) bool {
	if !reTiempo.MatchString(s) {
		return false
	}
	p := strings.Split(s, ":")
	return atoi(p[0]) <= 23 && atoi(p[1]) <= 59 && atoi(p[2]) <= 59
}

// fechaHora convierte "DD/MM/YYYY" + "hh:mm:ss" a la hora local (igual que date -d en el servidor).
func fechaHora(fecha, tiempo string) time.Time {
	f := strings.Split(fecha, "/")
	t := strings.Split(tiempo, ":")
	return time.Date(atoi(f[2]), time.Month(atoi(f[1])), atoi(f[0]), atoi(t[0]), atoi(t[1]), atoi(t[2]), 0, time.Local)
}

const formatoCDR = "20060102150405"

// ---------------------------------------------------------------- numeros

var reIntSinPrefijo = regexp.MustCompile(`^[1-9][0-9]{10,14}$`)

func quitar(s, chars string) string {
	return strings.Map(func(r rune) rune {
		if strings.ContainsRune(chars, r) {
			return -1
		}
		return r
	}, s)
}

// normalizaNumeroB: igual que la funcion del script. "+31 6 1234 5678" -> "0031612345678",
// "31612345678" -> "0031612345678". En marcacion CORTA no se usa.
func normalizaNumeroB(s, tipo string) string {
	if s == "-" || s == "" || strings.ToUpper(quitar(tipo, " \t")) == "CORTA" {
		return s
	}
	s = quitar(s, " ().-")
	if strings.HasPrefix(s, "+") {
		s = "00" + s[1:]
	}
	if reIntSinPrefijo.MatchString(s) {
		return "00" + s
	}
	return s
}

// normalizaVLR: sin espacios, sin + y sin 00 inicial (ej. +31 653131232 -> 31653131232).
func normalizaVLR(s string) string {
	s = quitar(s, " ().-")
	s = strings.TrimPrefix(s, "+")
	s = strings.TrimPrefix(s, "00")
	return s
}

func (g *Gen) digitos(n int) string {
	var b strings.Builder
	for i := 0; i < n; i++ {
		b.WriteByte(byte('0' + g.rnd.IntN(10)))
	}
	return b.String()
}

// completar agrega digitos aleatorios hasta tener 10 (como el for de seq en el script).
func (g *Gen) completar(header string) string {
	return header + g.digitos(10-len(header))
}

func campo(linea string, n int, sep string) string {
	c := strings.Split(linea, sep)
	if n-1 < len(c) {
		return c[n-1]
	}
	return ""
}

func (g *Gen) elegir(lineas []string) string {
	if len(lineas) == 0 {
		return ""
	}
	return campo(lineas[g.rnd.IntN(len(lineas))], 1, "@")
}

// headerAleatorio: una linea al azar de headers.txt (desde la 2, la 1 es encabezado).
func (g *Gen) headerAleatorio() string {
	if len(g.hd) < 2 {
		return ""
	}
	return g.elegir(g.hd[1:])
}

func (g *Gen) headerTelcel() string {
	var l []string
	for _, x := range g.hd {
		if strings.Contains(strings.ToLower(x), "telcel") {
			l = append(l, x)
		}
	}
	return g.elegir(l)
}

// patrones de grep -Ei "@$edo@" (si edo tiene varias lineas grep las toma como varios patrones).
func patronesEstado(edo string) []string {
	return strings.Split(strings.ToLower("@"+edo+"@"), "\n")
}

func coincide(linea string, pats []string) bool {
	l := strings.ToLower(linea)
	for _, p := range pats {
		if strings.Contains(l, p) {
			return true
		}
	}
	return false
}

func (g *Gen) lineasEstado(edo string) []string {
	pats := patronesEstado(edo)
	var r []string
	for _, l := range g.nh {
		if coincide(l, pats) {
			r = append(r, l)
		}
	}
	return r
}

func (g *Gen) headerEstado(edo string) string { return g.elegir(g.lineasEstado(edo)) }

func (g *Gen) headerTelcelEstado(edo string) string {
	var l []string
	for _, x := range g.lineasEstado(edo) {
		if strings.Contains(strings.ToLower(x), "telcel") {
			l = append(l, x)
		}
	}
	return g.elegir(l)
}

// numeroGrupo: numero del grupo destino internacional (grep -Ei "^$destino\_" | head -1).
func (g *Gen) numeroGrupo(destino string) (string, bool) {
	pref := strings.ToLower(destino) + "_"
	for _, l := range g.grupos {
		if strings.HasPrefix(strings.ToLower(l), pref) {
			return campo(l, 2, "_"), true
		}
	}
	return "", false
}

// ---------------------------------------------------------------- clasificacion B / destino

type clasif struct {
	opcion     string // Nacional / Internacional
	op         string
	edo        string
	contEdo    int
	contPais   bool
	contBOnly  string
	contBInEdo bool
	contInt    bool
}

// clasificar replica la seccion "MOD 5-6-2020" (ya corregida) que decide si el CDR es
// Nacional o Internacional a partir del numero de B, el destino y el tipo de marcacion.
func (g *Gen) clasificar(b, destino, tipo string) (*clasif, error) {
	c := &clasif{}
	edo := destino
	if edo == "-" {
		edo = ""
	}
	for _, n := range []int{5, 6, 7} {
		if len(b) < n {
			continue
		}
		pref := b[:n]
		encontrado := false
		for _, l := range g.nh {
			if strings.HasPrefix(l, pref+"@") {
				encontrado = true
				break
			}
		}
		if !encontrado {
			continue
		}
		c.contBOnly = pref
		if edo == "" {
			var estados []string
			for _, l := range g.nh {
				if strings.Contains(l, pref) {
					estados = append(estados, campo(l, 6, "@"))
				}
			}
			edo = strings.TrimRight(strings.Join(estados, "\n"), "\n")
		}
		c.opcion, c.op = "Nacional", "NORMAL"
	}
	c.edo = edo

	if edo != "" {
		for _, l := range g.lineasEstado(edo) {
			c.contEdo++
			if strings.HasPrefix(l, c.contBOnly+"@") {
				c.contBInEdo = true
			}
		}
		pats := strings.Split(strings.ToLower("^"+edo+"_"), "\n")
		for _, l := range g.grupos {
			ll := strings.ToLower(l)
			for _, p := range pats {
				if (strings.HasPrefix(p, "^") && p != "^" && strings.HasPrefix(ll, p[1:])) ||
					(!strings.HasPrefix(p, "^") && p != "" && strings.Contains(ll, p)) {
					c.contPais = true
				}
			}
		}
	}
	c.contInt = strings.HasPrefix(b, "00")
	g.logf("numero B:--%s--  destino:--%s--", b, strings.ReplaceAll(edo, "\n", ","))

	lenB := len(b)
	if edo == "" && b == "-" {
		c.opcion = "Nacional"
	}
	if b == "-" && c.contEdo != 0 {
		c.opcion = "Nacional"
	}
	if c.contBInEdo && lenB == 10 {
		c.opcion = "Nacional"
	}
	if c.contBOnly != "" && edo == "" && lenB == 10 {
		c.opcion = "Nacional"
	}
	if !c.contBInEdo && b != "-" && c.contBOnly == "" && !c.contInt && tipo != "CORTA" {
		return nil, salida("Verifique el numero de B")
	}
	if c.contEdo == 0 && edo != "" && b != "-" && !c.contPais && !c.contInt {
		return nil, salida("Verifique el Destino")
	}
	if !c.contBInEdo && edo == "" && b != "-" && !c.contInt && tipo != "CORTA" {
		return nil, salida("Verifique el Numero/Destino de B")
	}
	if c.contBOnly != "" && edo == "" && lenB != 10 {
		g.logf("Verifique el numero de B")
	}
	if c.contPais {
		c.opcion, c.op = "Internacional", "NORMAL"
	}
	if c.contPais && b != "-" && !c.contInt {
		return nil, salida("Verifique el numero de B")
	}
	if c.contBInEdo {
		c.opcion = "Nacional"
	}
	if c.contInt {
		c.opcion, c.op = "Internacional", "NORMAL"
	}
	if tipo == "CORTA" {
		c.opcion, c.op = "Nacional", "CORTA"
	}
	if edo != "" && !c.contPais && c.contEdo == 0 && !c.contInt {
		return nil, salida("Verifique el destino")
	}
	return c, nil
}

// ---------------------------------------------------------------- control de archivos

// archivoSalida replica la parte "DETERMINO SI SE VA A CREAR UN NUEVO ARCHIVO DE SALIDA".
func (g *Gen) archivoSalida(tipo, respuesta string) (numArchivos, numeroLinea int, nuevo bool, err error) {
	ultimo, err := g.leerEntero("ultimo_numero_" + tipo + "_nacional.txt")
	if err != nil {
		return
	}
	ejec, err := g.leerEntero("ejecucion_" + tipo + "_nacional.txt")
	if err != nil {
		return
	}
	nuevo = respuesta == "y" || respuesta == "Y" || respuesta == "S" || respuesta == "s"
	if nuevo || ultimo-1 == 100000 {
		if ultimo-1 == 100000 {
			g.logf("Advertencia: el archivo llego al maximo de registros, se generara un nuevo archivo")
		}
		return ejec + 1, 1, nuevo, nil
	}
	if ejec == 0 {
		return 1, 1, nuevo, nil
	}
	return ejec, ultimo, nuevo, nil
}

func (g *Gen) validarComunes(fecha, numCDRs, numA, imsi string) (int, error) {
	if !reCDRs.MatchString(numCDRs) || atoi(numCDRs) < 1 || atoi(numCDRs) > 100000 {
		return 0, salida("Numero de CDRs no admitido (1 a 100000)")
	}
	if !g.validaFecha(fecha) {
		return 0, salida("Fecha no valida (DD/MM/YYYY)")
	}
	if !reNumA.MatchString(numA) {
		return 0, salida("Numero de A incorrecto (10 digitos)")
	}
	if !reIMSI.MatchString(imsi) {
		return 0, salida("IMSI incorrecto (15 digitos)")
	}
	return atoi(numCDRs), nil
}
