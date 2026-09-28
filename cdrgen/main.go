// Generador de CDRs de voz y SMS para probar en la PC antes de subir los scripts al servidor.
//
// Uso:
//
//	GeneradorCDR.exe                      abre la pagina local en el navegador
//	GeneradorCDR.exe voz <parametros...>  mismos parametros que new_voz_nacional_campos.sh
//	GeneradorCDR.exe sms <parametros...>  mismos parametros que new_sms_nacional_campos.sh
//
// Los archivos se escriben en datos/ y CDR/ junto al .exe (o en la carpeta indicada con -dir),
// con el mismo formato que en el servidor.
package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"sync"
)

var mu sync.Mutex // una generacion a la vez (contadores y archivos compartidos)

func generar(base, tipo string, params []string) *Resultado {
	mu.Lock()
	defer mu.Unlock()
	g := nuevoGen(base)
	res := &Resultado{Tipo: tipo, Params: params}
	var err error
	switch tipo {
	case "voz":
		err = g.voz(params, res)
	case "sms":
		err = g.sms(params, res)
	default:
		err = fmt.Errorf("tipo desconocido: %s", tipo)
	}
	if err != nil {
		if esSalida(err) {
			g.logf("%s\n----------EXIT----------", err)
		} else {
			g.logf("ERROR: %s", err)
		}
		res.Error = err.Error()
		res.Lineas, res.Contenido, res.Archivos = nil, nil, nil
	}
	res.Log = g.log.String()
	res.Avisos = g.avisos
	return res
}

func carpetaBase(dir string) string {
	if dir != "" {
		if abs, err := filepath.Abs(dir); err == nil {
			return abs
		}
		return dir
	}
	if exe, err := os.Executable(); err == nil {
		if real, err := filepath.EvalSymlinks(exe); err == nil {
			exe = real
		}
		return filepath.Dir(exe)
	}
	wd, _ := os.Getwd()
	return wd
}

func uso() {
	fmt.Fprint(os.Stderr, `Generador de CDRs (voz y SMS) - prueba local

  GeneradorCDR.exe                     abre la pagina local en el navegador
  GeneradorCDR.exe voz <parametros>    igual que: bash new_voz_nacional_campos.sh <parametros>
  GeneradorCDR.exe sms <parametros>    igual que: bash new_sms_nacional_campos.sh <parametros>

Parametros de voz:
  fecha(DD/MM/YYYY) cdrs numA imsi numB|- destino|- ENTRANTE|SALIENTE|PATROCINADA
  horaIni|- horaFin|- idMatriz|- NORMAL|CORTA|PORCOBRAR|VIDEOLLAMADA nuevoArchivo(y/n) vlrRoaming|-
Parametros de SMS:
  fecha(DD/MM/YYYY) cdrs numA imsi numB|- destino|- ENTRANTE|SALIENTE
  hora idMatriz|- NORMAL|CORTA|PORCOBRAR nuevoArchivo(y/n) RP|- vlrRoaming|-

Ejemplo (llamada en roaming en Paises Bajos a un numero de Paises Bajos):
  GeneradorCDR.exe voz 28/09/2026 1 5512345678 334020123456789 0031612345678 - SALIENTE 10:00:00 10:05:00 - NORMAL n 31653131232

Opciones:
`)
	flag.PrintDefaults()
}

func main() {
	dir := flag.String("dir", "", "carpeta de trabajo con datos/ y CDR/ (por defecto la carpeta del .exe)")
	puerto := flag.Int("puerto", 8765, "puerto de la pagina local")
	noAbrir := flag.Bool("no-abrir", false, "no abrir el navegador automaticamente")
	flag.Usage = uso
	flag.Parse()
	base := carpetaBase(*dir)

	args := flag.Args()
	if len(args) == 0 {
		if err := servirWeb(base, *puerto, !*noAbrir); err != nil {
			fmt.Fprintln(os.Stderr, "ERROR:", err)
			esperarEnter()
			os.Exit(1)
		}
		return
	}

	tipo := strings.ToLower(args[0])
	if tipo != "voz" && tipo != "sms" {
		uso()
		os.Exit(2)
	}
	res := generar(base, tipo, args[1:])
	fmt.Print(res.Log)
	for _, l := range res.Lineas {
		fmt.Println(l)
	}
	for _, a := range res.Archivos {
		fmt.Println("Archivo:", filepath.Join(base, filepath.FromSlash(a)))
	}
	if res.Error != "" {
		os.Exit(1)
	}
}

func esperarEnter() {
	fmt.Fprintln(os.Stderr, "Presione ENTER para cerrar")
	fmt.Scanln()
}
