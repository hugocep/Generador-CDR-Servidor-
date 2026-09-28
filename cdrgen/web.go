package main

import (
	"embed"
	"encoding/json"
	"errors"
	"fmt"
	"net"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"sort"
	"strconv"
	"strings"
	"time"
)

//go:embed web/index.html
var webFS embed.FS

type formulario struct {
	Tipo      string `json:"tipo"`
	Fecha     string `json:"fecha"` // YYYY-MM-DD (input date) o DD/MM/YYYY
	CDRs      string `json:"cdrs"`
	A         string `json:"a"`
	IMSI      string `json:"imsi"`
	B         string `json:"b"`
	Destino   string `json:"destino"`
	Direccion string `json:"direccion"`
	HoraIni   string `json:"horaIni"`
	HoraFin   string `json:"horaFin"`
	ID        string `json:"id"`
	Marcacion string `json:"marcacion"`
	Nuevo     bool   `json:"nuevo"`
	RP        bool   `json:"rp"`
	VLR       string `json:"vlr"`
}

func guion(s string) string {
	s = strings.TrimSpace(s)
	if s == "" {
		return "-"
	}
	return s
}

func fechaParam(s string) string {
	s = strings.TrimSpace(s)
	if t, err := time.Parse("2006-01-02", s); err == nil {
		return t.Format("02/01/2006")
	}
	return s
}

// hora: el input time del navegador manda hh:mm o hh:mm:ss
func horaParam(s string) string {
	s = strings.TrimSpace(s)
	if len(s) == 5 && strings.Count(s, ":") == 1 {
		return s + ":00"
	}
	return guion(s)
}

// params arma la lista de parametros posicionales igual que la pagina del servidor.
func (f formulario) params() []string {
	yn := "n"
	if f.Nuevo {
		yn = "y"
	}
	comunes := []string{fechaParam(f.Fecha), strings.TrimSpace(f.CDRs), strings.TrimSpace(f.A), strings.TrimSpace(f.IMSI),
		guion(f.B), guion(f.Destino), f.Direccion, horaParam(f.HoraIni)}
	if f.Tipo == "voz" {
		return append(comunes, horaParam(f.HoraFin), guion(f.ID), f.Marcacion, yn, guion(f.VLR))
	}
	rp := "-"
	if f.RP {
		rp = "RP"
	}
	return append(comunes, guion(f.ID), f.Marcacion, yn, rp, guion(f.VLR))
}

func comando(tipo string, p []string) string {
	q := make([]string, len(p))
	for i, x := range p {
		if x == "" || strings.ContainsAny(x, " '\"$*") {
			x = "'" + strings.ReplaceAll(x, "'", `'\''`) + "'"
		}
		q[i] = x
	}
	return "bash new_" + tipo + "_nacional_campos.sh " + strings.Join(q, " ")
}

type campoCDR struct {
	N     int    `json:"n"`
	Valor string `json:"valor"`
	Desc  string `json:"desc"`
}

type detalleLinea struct {
	Linea   string     `json:"linea"`
	Resumen string     `json:"resumen"`
	Campos  []campoCDR `json:"campos"`
}

var descVoz = map[int]string{
	1: "Service key", 2: "Tipo de llamada (vacio = por cobrar)", 3: "Numero llamante", 4: "Numero llamado",
	7: "Fecha/hora de inicio", 9: "Numero llamado / servido", 10: "Numero conectado",
	11: "Direccion (0 saliente, 1 entrante)", 13: "VLR del llamante (saliente; roaming aqui)",
	14: "Cell ID llamante", 15: "VLR del llamado (entrante; roaming aqui)", 16: "Cell ID llamado",
	17: "Numero marcado", 19: "Tipo de CDR (0 llamada, 8 videollamada)", 24: "IMSI",
	27: "Zona horaria (vacio = hora local)", 28: "Fecha/hora de cobro", 29: "Duracion (seg)",
	31: "Duracion cobrada (seg)", 35: "ID matriz", 42: "Tipo de numero A", 43: "Tipo de numero B",
	44: "Tipo de marcacion (0 normal, 1 por cobrar, 2 corta)", 47: "2 normal / 1 por cobrar",
	52: "Nombre del archivo", 53: "Numero de linea",
}

var descSMS = map[int]string{
	1: "Tipo de registro", 8: "Numero origen (remitente)", 9: "Numero destino", 10: "Numero cobrado",
	11: "Direccion (1 saliente, 2 entrante / por cobrar)", 19: "Fecha/hora", 36: "Numero del cliente",
	37: "ID matriz", 42: "Tipo de numero", 43: "Tipo de numero", 46: "Otro numero",
	47: "Nombre del archivo", 48: "Numero de linea", 51: "Bandera (1 = roaming / RP / por cobrar)",
	52: "Bandera (1 = roaming / RP / por cobrar)", 53: "IMSI", 56: "VLR (saliente; roaming aqui)",
	58: "VLR (entrante; roaming aqui)",
}

// Codigos de pais solo para mostrar el resumen (el script no los usa).
var paises = map[string]string{
	"1": "EUA/Canada", "7": "Rusia", "20": "Egipto", "27": "Sudafrica", "30": "Grecia", "31": "Paises Bajos",
	"32": "Belgica", "33": "Francia", "34": "Espana", "36": "Hungria", "39": "Italia", "40": "Rumania",
	"41": "Suiza", "43": "Austria", "44": "Reino Unido", "45": "Dinamarca", "46": "Suecia", "47": "Noruega",
	"48": "Polonia", "49": "Alemania", "51": "Peru", "52": "Mexico", "53": "Cuba", "54": "Argentina",
	"55": "Brasil", "56": "Chile", "57": "Colombia", "58": "Venezuela", "60": "Malasia", "61": "Australia",
	"62": "Indonesia", "63": "Filipinas", "64": "Nueva Zelanda", "65": "Singapur", "66": "Tailandia",
	"81": "Japon", "82": "Corea del Sur", "84": "Vietnam", "86": "China", "90": "Turquia", "91": "India",
	"93": "Afganistan", "351": "Portugal", "352": "Luxemburgo", "353": "Irlanda", "354": "Islandia",
	"358": "Finlandia", "370": "Lituania", "377": "Monaco", "380": "Ucrania", "385": "Croacia",
	"420": "Rep. Checa", "421": "Eslovaquia", "501": "Belice", "502": "Guatemala", "503": "El Salvador",
	"504": "Honduras", "505": "Nicaragua", "506": "Costa Rica", "507": "Panama", "591": "Bolivia",
	"593": "Ecuador", "595": "Paraguay", "598": "Uruguay", "870": "Satelital (Inmarsat)",
	"881": "Satelital", "882": "Satelital", "971": "Emiratos Arabes", "972": "Israel", "966": "Arabia Saudita",
}

func paisDe(num string, conCeros bool) string {
	n := strings.TrimPrefix(num, "B033")
	if conCeros {
		if !strings.HasPrefix(n, "00") {
			if len(n) <= 8 {
				return "numero corto"
			}
			return "?"
		}
		n = n[2:]
	}
	for l := 3; l >= 1; l-- {
		if len(n) >= l {
			if p, ok := paises[n[:l]]; ok {
				return p + " +" + n[:l]
			}
		}
	}
	return "?"
}

func detalle(tipo, linea string) detalleLinea {
	c := strings.Split(strings.TrimSuffix(linea, "|"), "|")
	desc := descSMS
	if tipo == "voz" {
		desc = descVoz
	}
	d := detalleLinea{Linea: linea}
	for i, v := range c {
		d.Campos = append(d.Campos, campoCDR{N: i + 1, Valor: v, Desc: desc[i+1]})
	}
	get := func(n int) string {
		if n-1 < len(c) {
			return c[n-1]
		}
		return ""
	}
	vlr := func(v string) string {
		if v == "" {
			return "(vacio)"
		}
		if v == vlrTelcel {
			return v + " (Telcel Mexico, sin roaming)"
		}
		return v + " (" + paisDe(v, false) + ")"
	}
	if tipo == "voz" {
		d.Resumen = fmt.Sprintf("Llamante %s (%s) -> Llamado %s (%s) | VLR saliente: %s | VLR entrante: %s | %s seg",
			get(3), paisDe(get(3), true), get(4), paisDe(get(4), true), vlr(get(13)), vlr(get(15)), get(29))
	} else {
		d.Resumen = fmt.Sprintf("Origen %s (%s) -> Destino %s (%s) | VLR campo 56: %s | VLR campo 58: %s",
			get(8), paisDe(get(8), true), get(9), paisDe(get(9), true), vlr(get(56)), vlr(get(58)))
	}
	return d
}

type respuestaGenerar struct {
	*Resultado
	Comando  string         `json:"comando"`
	Detalles []detalleLinea `json:"detalles"`
	Base     string         `json:"base"`
}

type opciones struct {
	Grupos  []string `json:"grupos"`
	Estados []string `json:"estados"`
	Avisos  []string `json:"avisos"`
	Base    string   `json:"base"`
}

func leerOpciones(base string) opciones {
	o := opciones{Base: base}
	g := nuevoGen(base)
	if l, err := leerLineas(g.rutaDatos("origen_nacional_destino_internacional.txt")); err == nil {
		for _, x := range l {
			if k := campo(x, 1, "_"); k != "" {
				o.Grupos = append(o.Grupos, k+" ("+campo(x, 2, "_")+")")
			}
		}
	} else {
		for _, x := range strings.Split(strings.TrimSpace(defOrigenNacDestinoInt), "\n") {
			o.Grupos = append(o.Grupos, campo(x, 1, "_")+" ("+campo(x, 2, "_")+")")
		}
		o.Grupos = append(o.Grupos, "NLD (0031612345678)")
	}
	vistos := map[string]bool{}
	if l, err := leerLineas(g.rutaDatos("new_headers.txt")); err == nil {
		for _, x := range l {
			if e := strings.TrimSpace(campo(x, 6, "@")); e != "" && !vistos[e] {
				vistos[e] = true
				o.Estados = append(o.Estados, e)
			}
		}
		sort.Strings(o.Estados)
	} else {
		o.Avisos = append(o.Avisos, "No se encontro datos/new_headers.txt ni datos/headers.txt en "+filepath.Join(base, "datos")+
			". Copielos del servidor para validar numeros de B nacionales y generar numeros aleatorios reales (mientras tanto se usa una lista minima de prueba).")
	}
	return o
}

type archivoInfo struct {
	Ruta   string `json:"ruta"`
	Tam    int64  `json:"tam"`
	Lineas int    `json:"lineas"`
	Fecha  string `json:"fecha"`
}

func listarArchivos(base string) []archivoInfo {
	var r []archivoInfo
	for _, sub := range []string{"VOZ", "SMS"} {
		dir := filepath.Join(base, "CDR", sub, "NACIONAL")
		ents, _ := os.ReadDir(dir)
		for _, e := range ents {
			if e.IsDir() {
				continue
			}
			info, err := e.Info()
			if err != nil {
				continue
			}
			b, _ := os.ReadFile(filepath.Join(dir, e.Name()))
			r = append(r, archivoInfo{Ruta: "CDR/" + sub + "/NACIONAL/" + e.Name(), Tam: info.Size(),
				Lineas: strings.Count(string(b), "\n"), Fecha: info.ModTime().Format("02/01/2006 15:04:05")})
		}
	}
	sort.Slice(r, func(i, j int) bool { return r[i].Fecha > r[j].Fecha })
	return r
}

func escribirJSON(w http.ResponseWriter, v any) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	json.NewEncoder(w).Encode(v)
}

// rutaSegura valida que la ruta pedida quede dentro de base/CDR.
func rutaSegura(base, rel string) (string, error) {
	dirCDR := filepath.Join(base, "CDR")
	p := filepath.Join(base, filepath.FromSlash(rel))
	r, err := filepath.Rel(dirCDR, p)
	if err != nil || r == ".." || strings.HasPrefix(r, ".."+string(filepath.Separator)) || filepath.IsAbs(r) {
		return "", errors.New("ruta no permitida")
	}
	return p, nil
}

func abrir(destino string) error {
	switch runtime.GOOS {
	case "windows":
		if strings.HasPrefix(destino, "http") {
			return exec.Command("rundll32", "url.dll,FileProtocolHandler", destino).Start()
		}
		return exec.Command("explorer", destino).Start()
	case "darwin":
		return exec.Command("open", destino).Start()
	default:
		return exec.Command("xdg-open", destino).Start()
	}
}

func servirWeb(base string, puerto int, abrirNavegador bool) error {
	mux := http.NewServeMux()
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/" {
			http.NotFound(w, r)
			return
		}
		b, _ := webFS.ReadFile("web/index.html")
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		w.Write(b)
	})
	mux.HandleFunc("/favicon.ico", func(w http.ResponseWriter, r *http.Request) { w.WriteHeader(http.StatusNoContent) })
	mux.HandleFunc("/api/opciones", func(w http.ResponseWriter, r *http.Request) {
		escribirJSON(w, leerOpciones(base))
	})
	mux.HandleFunc("/api/generar", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "metodo no permitido", http.StatusMethodNotAllowed)
			return
		}
		var f formulario
		if err := json.NewDecoder(r.Body).Decode(&f); err != nil {
			http.Error(w, "datos invalidos: "+err.Error(), http.StatusBadRequest)
			return
		}
		if f.Tipo != "voz" && f.Tipo != "sms" {
			http.Error(w, "tipo invalido", http.StatusBadRequest)
			return
		}
		p := f.params()
		res := generar(base, f.Tipo, p)
		resp := respuestaGenerar{Resultado: res, Comando: comando(f.Tipo, p), Base: base}
		for i, l := range res.Lineas {
			if i >= 50 {
				break
			}
			resp.Detalles = append(resp.Detalles, detalle(f.Tipo, l))
		}
		escribirJSON(w, resp)
	})
	mux.HandleFunc("/api/archivos", func(w http.ResponseWriter, r *http.Request) {
		escribirJSON(w, listarArchivos(base))
	})
	mux.HandleFunc("/descargar", func(w http.ResponseWriter, r *http.Request) {
		p, err := rutaSegura(base, r.URL.Query().Get("f"))
		if err != nil {
			http.Error(w, err.Error(), http.StatusForbidden)
			return
		}
		w.Header().Set("Content-Disposition", "attachment; filename=\""+filepath.Base(p)+"\"")
		w.Header().Set("Content-Type", "text/plain; charset=utf-8")
		http.ServeFile(w, r, p)
	})
	mux.HandleFunc("/api/abrir-carpeta", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "metodo no permitido", http.StatusMethodNotAllowed)
			return
		}
		dir := filepath.Join(base, "CDR")
		os.MkdirAll(dir, 0o755)
		if err := abrir(dir); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		escribirJSON(w, map[string]string{"ok": dir})
	})

	var ln net.Listener
	var err error
	for i := 0; i < 20; i++ {
		ln, err = net.Listen("tcp", "127.0.0.1:"+strconv.Itoa(puerto+i))
		if err == nil {
			break
		}
	}
	if err != nil {
		return fmt.Errorf("no se pudo abrir un puerto local: %w", err)
	}
	url := "http://" + ln.Addr().String() + "/"
	fmt.Println("Generador de CDRs - prueba local")
	fmt.Println("Carpeta de trabajo:", base)
	fmt.Println("Pagina:", url)
	fmt.Println("Deje esta ventana abierta mientras usa la pagina. Cierrela para terminar.")
	if abrirNavegador {
		abrir(url)
	}
	return http.Serve(ln, mux)
}
