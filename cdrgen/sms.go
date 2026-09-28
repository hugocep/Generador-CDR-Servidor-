package main

// Replica de servidor/new_sms_nacional_campos.sh (version corregida).
// Parametros (mismo orden que el script):
//  1 fecha DD/MM/YYYY   2 num. CDRs   3 numero A (10)   4 IMSI (15)   5 numero B o "-"
//  6 destino/estado o "-"   7 ENTRANTE/SALIENTE   8 hora hh:mm:ss   9 ID matriz o "-"
// 10 NORMAL/CORTA/PORCOBRAR   11 nuevo archivo y/n   12 RP o "-"   13 VLR roaming o "-"

import (
	"fmt"
	"path/filepath"
	"strconv"
	"strings"
	"time"
)

func (g *Gen) sms(p []string, res *Resultado) error {
	if err := g.prepararArchivos("sms"); err != nil {
		return err
	}
	numArchivos, numeroLinea, _, err := g.archivoSalida("sms", param(p, 11))
	if err != nil {
		return err
	}

	b := normalizaNumeroB(param(p, 5), param(p, 10))
	destino := param(p, 6)
	tipo := param(p, 10)
	p7 := param(p, 7)
	rp := param(p, 12) == "RP"
	c, err := g.clasificar(b, destino, tipo)
	if err != nil {
		return err
	}

	var var9, var42, var43, numInt string
	var nacional, porcobrar bool
	op := c.op
	switch c.opcion {
	case "Nacional":
		g.logf("---Destino Nacional---")
		nacional = true
		op = strings.ToUpper(quitar(tipo, " \t"))
		switch op {
		case "NORMAL":
			var42, var43 = "2", "2"
			if b == "-" {
				var9 = "0052" + g.completar(g.headerAleatorio())
				if c.edo != "" && c.contEdo != 0 {
					var9 = "0052" + g.completar(g.headerEstado(c.edo))
				}
			} else {
				if !reNumA.MatchString(b) {
					return salida("Numero de B incorrecto (debe tener 10 digitos)")
				}
				var9 = "0052" + b
			}
			if rp {
				var9 = "035" + var9
			}
		case "CORTA":
			var42, var43 = "0", "0"
			var9 = b
		case "PORCOBRAR":
			porcobrar = true
			var42, var43 = "2", "2"
		default:
			return salida("Opcion incorrecta. Revise el tipo de marcacion (parametro 10)")
		}
	case "Internacional":
		g.logf("---Destino Internacional---")
		if b == "-" {
			n, ok := g.numeroGrupo(destino)
			if !ok {
				return salida("Grupo destino incorrecto: " + destino)
			}
			numInt = n
		} else {
			numInt = b
		}
	default:
		return salida("Opcion incorrecta. Verifique el Numero/Destino de B")
	}

	n, err := g.validarComunes(param(p, 1), param(p, 2), param(p, 3), param(p, 4))
	if err != nil {
		return err
	}
	if !validaTiempo(param(p, 8)) {
		return salida("Hora no valida (hh:mm:ss)")
	}
	ini := fechaHora(param(p, 1), param(p, 8))
	numTel := param(p, 3)
	cliente := "0052" + numTel

	idInicio, err := g.siguienteIDMatriz("OCH")
	if err != nil {
		return err
	}
	idFinal := "OCH_" + strconv.Itoa(idInicio+n-1)

	direccion := p7
	if op == "PORCOBRAR" {
		direccion = "Entrante"
	}
	entSal := 0
	switch direccion {
	case "Entrante", "ENTRANTE", "entrante":
		g.logf("---Consumo Entrante---")
		entSal = 1
	case "Saliente", "saliente", "SALIENTE":
		g.logf("---Consumo Saliente---")
	default:
		return salida("Opcion incorrecta. Revise el tipo de consumo (parametro 7)")
	}

	vlr := normalizaVLR(param(p, 13))
	conVLR := reDigitos.MatchString(vlr)
	if conVLR {
		g.logf("---Roaming VLR: %s---", vlr)
	}
	imsi := param(p, 4)
	archivo := fmt.Sprintf("w_smo_SMSCobro_%s_%06d.unl", g.ahora().Format("20060102"), numArchivos)
	idMatriz := param(p, 9)
	var51, var52 := "", ""

	for i := 1; i <= n; i++ {
		v := make([]string, 60)
		v[1], v[2], v[5] = "3", "1", "174"

		v[8] = cliente
		if porcobrar && b == "-" {
			v[8] = "B0330052" + g.completar(g.headerTelcel())
			if c.edo != "" && c.contEdo != 0 {
				v[8] = "B0330052" + g.completar(g.headerTelcelEstado(c.edo))
			}
		}
		if porcobrar && b != "-" {
			v[8] = "B033" + b
		}
		if p7 == "ENTRANTE" && b == "-" && !porcobrar {
			v[8] = "0052" + g.completar(g.headerAleatorio())
			if c.edo != "" && c.contEdo != 0 {
				v[8] = "0052" + g.completar(g.headerEstado(c.edo))
			}
		}
		if p7 == "ENTRANTE" && b != "-" {
			v[8] = "0052" + b
		}
		if p7 == "ENTRANTE" && c.opcion == "Internacional" {
			v[8] = numInt
		}

		v[9] = var9
		if p7 == "SALIENTE" && c.opcion == "Internacional" {
			v[9] = numInt
		}
		if porcobrar || p7 == "ENTRANTE" {
			v[9] = cliente
		}

		v[10] = v[8]
		if porcobrar || entSal == 1 {
			v[10] = v[9]
		}
		if p7 == "ENTRANTE" {
			v[10] = cliente
		}

		v[11] = "1"
		if porcobrar || p7 == "ENTRANTE" {
			v[11] = "2"
		}
		v[12], v[17], v[18] = "0", "0", "0"
		v[19] = ini.Add(time.Duration(i-1) * time.Second).Format(formatoCDR)
		v[23] = "0"

		v[36] = v[8]
		if porcobrar {
			v[36] = v[9]
		}
		if p7 == "ENTRANTE" {
			v[36] = cliente
		}
		v[37] = "OCH" + strconv.Itoa(idInicio+i-1)
		if idMatriz != "-" {
			v[37] = idMatriz
		}

		if conVLR && !nacional {
			var42, var43 = "2", "2"
		}
		v[42], v[43] = var42, var43
		v[44], v[45] = "2", "2"

		v[46] = v[9]
		if rp {
			v[46] = strings.TrimPrefix(v[9], "035")
		}
		if porcobrar {
			v[46] = v[9]
		}
		if p7 == "ENTRANTE" {
			v[46] = v[36]
		}
		v[47] = archivo
		v[48] = strconv.Itoa(numeroLinea)
		numeroLinea++

		if porcobrar || rp || conVLR {
			var51, var52 = "1", "1"
		}
		v[51], v[52] = var51, var52
		v[53] = imsi

		v[56] = vlrTelcel
		if conVLR && direccion == "SALIENTE" {
			v[56] = vlr
		}
		if conVLR && direccion == "ENTRANTE" {
			v[56] = ""
		}
		if porcobrar {
			v[58] = vlrTelcel
		}
		if conVLR && direccion == "ENTRANTE" {
			v[58] = vlr
		}
		res.Lineas = append(res.Lineas, strings.Join(v[1:], "|")+"|")
	}

	rel := filepath.Join("CDR", "SMS", "NACIONAL", archivo)
	if err := g.agregarLineas(rel, res.Lineas); err != nil {
		return err
	}
	res.Archivos = append(res.Archivos, filepath.ToSlash(rel))
	if err := g.escribirEntero("ejecucion_sms_nacional.txt", numArchivos); err != nil {
		return err
	}
	if err := g.escribirEntero("ultimo_numero_sms_nacional.txt", numeroLinea); err != nil {
		return err
	}
	return g.actualizarMatriz("OCH", idFinal)
}
