package main

// Replica de servidor/new_voz_nacional_campos.sh (version corregida).
// Parametros (mismo orden que el script):
//  1 fecha DD/MM/YYYY   2 num. CDRs   3 numero A (10)   4 IMSI (15)   5 numero B o "-"
//  6 destino/estado o "-"   7 ENTRANTE/SALIENTE/PATROCINADA   8 hora inicio o "-"
//  9 hora fin o "-"   10 ID matriz o "-"   11 NORMAL/CORTA/PORCOBRAR/VIDEOLLAMADA
// 12 nuevo archivo y/n   13 VLR roaming o "-"

import (
	"fmt"
	"path/filepath"
	"strconv"
	"strings"
	"time"
)

func (g *Gen) voz(p []string, res *Resultado) error {
	if err := g.prepararArchivos("voz"); err != nil {
		return err
	}
	numArchivos, numeroLinea, _, err := g.archivoSalida("voz", param(p, 12))
	if err != nil {
		return err
	}

	b := normalizaNumeroB(param(p, 5), param(p, 11))
	destino := param(p, 6)
	tipo := param(p, 11)
	c, err := g.clasificar(b, destino, tipo)
	if err != nil {
		return err
	}

	var var8, var42, var43, numeroB string
	var corta, porcobrar bool
	op := c.op
	switch c.opcion {
	case "Nacional":
		g.logf("---Destino Nacional---")
		op = strings.ToUpper(quitar(tipo, " \t"))
		switch op {
		case "NORMAL", "VIDEOLLAMADA":
			var8, var42, var43 = "0", "2", "2"
			if b == "-" {
				numeroB = "0052" + g.completar(g.headerAleatorio())
				if c.edo != "" && c.contEdo != 0 {
					numeroB = "0052" + g.completar(g.headerEstado(c.edo))
				}
			} else {
				if !reNumA.MatchString(b) {
					return salida("Numero de B incorrecto (debe tener 10 digitos)")
				}
				numeroB = "0052" + b
			}
		case "CORTA":
			var8, var42, var43 = "0", "0", "1"
			corta = true
			numeroB = "0052" + b
		case "PORCOBRAR":
			porcobrar = true
			var8, var42, var43 = "0", "1", "1"
			if b == "-" {
				numeroB = "B033" + g.completar(g.headerAleatorio())
				if c.edo != "" && c.contEdo != 0 {
					numeroB = "B033" + g.completar(g.headerEstado(c.edo))
				}
			} else {
				if !reNumA.MatchString(b) {
					return salida("Numero de B incorrecto (debe tener 10 digitos)")
				}
				numeroB = "B033" + b
			}
		default:
			return salida("Opcion incorrecta. Revise el campo 11 (tipo de marcacion)")
		}
	case "Internacional":
		g.logf("---Destino Internacional---")
		var8, var42, var43 = "0", "2", "2"
		if b == "-" {
			n, ok := g.numeroGrupo(destino)
			if !ok {
				return salida("Grupo destino incorrecto: " + destino)
			}
			numeroB = n
		} else {
			numeroB = b
		}
	default:
		return salida("Opcion incorrecta")
	}

	n, err := g.validarComunes(param(p, 1), param(p, 2), param(p, 3), param(p, 4))
	if err != nil {
		return err
	}
	fechaInicio := param(p, 1)

	tiempoInicial := param(p, 8)
	if tiempoInicial == "-" {
		tiempoInicial = fmt.Sprintf("%d:%d:%d", g.rnd.IntN(24), g.rnd.IntN(60), g.rnd.IntN(60))
	}
	if !validaTiempo(tiempoInicial) {
		return salida("Hora inicial no valida (hh:mm:ss)")
	}
	ini := fechaHora(fechaInicio, tiempoInicial)

	fechaFin := fechaInicio
	tiempoFinal := param(p, 9)
	if tiempoFinal == "-" {
		t := ini.Add(time.Duration(30+g.rnd.IntN(3571)) * time.Second)
		tiempoFinal = t.Format("15:04:05")
		fechaFin = t.Format("02/01/2006")
	}
	if !validaTiempo(tiempoFinal) {
		return salida("Hora final no valida (hh:mm:ss)")
	}
	fin := fechaHora(fechaFin, tiempoFinal)
	if fin.Before(ini) {
		f := fechaHora(fechaFin, "0:0:0").AddDate(0, 0, 1)
		fechaFin = f.Format("02/01/2006")
		fin = fechaHora(fechaFin, tiempoFinal)
		g.logf("Advertencia: la hora final es menor que la inicial, se suma un dia (fin: %s %s)", fechaFin, tiempoFinal)
	}
	total := int(fin.Sub(ini) / time.Second)
	if total < 0 {
		total = -total
	}
	if total == 0 {
		return salida("La hora final es igual a la inicial: capture una hora final diferente")
	}
	cdrXseg := total / n

	numTel := param(p, 3)
	numeroA := "0052" + numTel
	if porcobrar {
		numeroA = numTel
	}

	idInicio, err := g.siguienteIDMatriz("OCZ")
	if err != nil {
		return err
	}
	idFinal := "OCZ_" + strconv.Itoa(idInicio+n-1)

	direccion := param(p, 7)
	if op == "PORCOBRAR" && param(p, 7) == "PATROCINADA" {
		direccion = "SALIENTE"
	}
	var var3, var4, var9, var10, var11, var13, var15, var17 string
	entrante := false
	switch direccion {
	case "Entrante", "ENTRANTE", "entrante":
		g.logf("---Consumo Entrante---")
		entrante = true
		var11, var3, var4, var9, var10, var13, var15, var17 = "1", numeroB, numeroA, numeroA, numeroA, "", vlrTelcel, numeroA
		if porcobrar {
			var13, var17 = vlrTelcel, ""
		}
	case "Saliente", "SALIENTE", "saliente":
		g.logf("---Consumo Saliente---")
		var11, var3, var4, var9, var10, var13, var15, var17 = "0", numeroA, numeroB, numeroB, numeroB, vlrTelcel, "", numeroB
		if porcobrar {
			var13, var17 = vlrTelcel, ""
		}
	default:
		return salida("Opcion incorrecta. Revise el campo 7 (ENTRANTE/SALIENTE)")
	}

	// ROAMING: el VLR del parametro 13 reemplaza al de Telcel (campo 13 saliente / 15 entrante)
	vlr := normalizaVLR(param(p, 13))
	if reDigitos.MatchString(vlr) {
		g.logf("---Roaming VLR: %s---", vlr)
		if entrante {
			var15 = vlr
		} else {
			var13 = vlr
		}
	}

	var19 := "0"
	if param(p, 11) == "VIDEOLLAMADA" {
		var19 = "8"
	}
	imsi := param(p, 4)

	hoy := g.ahora().Format("20060102")
	archivo := fmt.Sprintf("w_abr_VMS_%s_%06d.unl", hoy, numArchivos)
	contenido := fmt.Sprintf("Content_SRS_%s_%04d.unl", hoy, numArchivos)
	idMatriz := param(p, 10)

	for i := 1; i <= n; i++ {
		if i == n {
			cdrXseg += total % n
		}
		v := make([]string, 65)
		v[1] = "91"
		if !porcobrar {
			v[2] = "0"
		}
		v[3], v[4] = var3, var4
		v[7] = ini.Add(time.Duration(cdrXseg*(i-1)) * time.Second).Format(formatoCDR)
		v[8], v[9], v[10], v[11] = var8, var9, var10, var11
		v[13], v[15], v[17] = var13, var15, var17
		if !porcobrar {
			v[19] = var19
		}
		v[23] = "0"
		v[24] = imsi
		v[28] = v[7]
		v[29] = strconv.Itoa(cdrXseg)
		v[30] = "0"
		v[31] = strconv.Itoa(cdrXseg)
		v[32] = "-1"
		if !porcobrar {
			v[33] = "0"
		}
		v[34] = "0"
		v[35] = "OCZ" + strconv.Itoa(idInicio+i-1)
		if idMatriz != "-" {
			v[35] = idMatriz
		}
		v[41] = "0"
		v[42], v[43] = var42, var43
		v[44] = "0"
		if porcobrar {
			v[44] = "1"
		}
		if corta {
			v[44] = "2"
		}
		v[45], v[46] = "2", "2"
		v[47] = "2"
		if porcobrar {
			v[47] = "1"
			v[50] = "0"
			v[56] = "4"
			v[57] = "1"
		}
		v[52] = archivo
		v[53] = strconv.Itoa(numeroLinea)
		numeroLinea++
		res.Lineas = append(res.Lineas, strings.Join(v[1:], "|")+"|")
		if porcobrar {
			res.Contenido = append(res.Contenido, strings.ReplaceAll(v[35], "OCZ", "SCD")+"|4|"+v[7]+"|0|"+numeroA+
				"|0||-2|1103||5||CVMQ@huawei.com|||||||||||||||||"+contenido+"|"+v[53]+"|")
		}
	}

	dirCDR := filepath.Join("CDR", "VOZ", "NACIONAL")
	if err := g.agregarLineas(filepath.Join(dirCDR, archivo), res.Lineas); err != nil {
		return err
	}
	res.Archivos = append(res.Archivos, filepath.ToSlash(filepath.Join(dirCDR, archivo)))
	if porcobrar {
		if err := g.agregarLineas(filepath.Join(dirCDR, contenido), res.Contenido); err != nil {
			return err
		}
		res.Archivos = append(res.Archivos, filepath.ToSlash(filepath.Join(dirCDR, contenido)))
	}
	if err := g.escribirEntero("ejecucion_voz_nacional.txt", numArchivos); err != nil {
		return err
	}
	if err := g.escribirEntero("ultimo_numero_voz_nacional.txt", numeroLinea); err != nil {
		return err
	}
	return g.actualizarMatriz("OCZ", idFinal)
}
