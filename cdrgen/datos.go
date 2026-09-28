package main

// Manejo de la carpeta datos/ igual que los scripts new_voz_nacional_campos.sh y
// new_sms_nacional_campos.sh: mismos archivos, mismo formato y mismos contadores,
// para que se pueda copiar la carpeta datos entre la PC y el servidor.

import (
	"fmt"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

const (
	defMatrices = "OCA_0\nOCB_0\nOCC_0\nOCD_0\nOCE_0\nOCF_0\nOCG_0\nOCH_0\nOCI_0\nOCJ_0\nSCA_0\nSCB_0\nSCC_0\nSCD_0\nSCE_0\nSCF_0\nSCG_0\nSCH_0\nSCI_0\nSCJ_0\nSCK_0\nSCL_0\nSCM_0\nSCN_0\nSCO_0\nSCP_0\nSCQ_0\nSCR_0\nSCS_0\nSCT_0\nSCU_0\nSCV_0\nSCW_0\nSCX_0\nRCA_0\nRCB_0\nRCC_0\nRCD_0\nRCE_0\nRCF_0\nRCG_0\nRCH_0\nRCI_0\nRCJ_0\nRCK_0\nRCL_0\nRCM_0\nRCN_0\nRCO_0\nRCP_0\nRCQ_0\nRCR_0\nRCS_0\nRCT_0\nRCU_0\nRCV_0\nRCW_0\nRCX_0\nRCY_0\nRCZ_0\nRCZA_0\nRCZB_0\nRCZC_0\nRCZD_0\nRCZE_0\nRCZF_0\nFCA_0\nFCB_0\nFCC_0\nFCD_0\nFCE_0\nFCF_0\nOCFA_0\n"

	defOrigenInternacional = "ACA_73001_CHLMV\nACB_37002_DOMCL\nASA_72231_ARGCM\nCAN_30261_CANBM\nCUB_36801_CUB01\nEUP_26201_DEUD1\nGUA_70402_GTMCM\nMA2_90112_NORMC\nMAR_90118_BMU01\nMUN_33807_JAMCL\nPEF_20822_FRATR\nPRI_33011_PRICL\nR2A_42507_ISRMS\nRE1_25001_RUS01\nRE2_36011_VCTCW\nREB_64801_ZWEN1\nREC_73406_VENMV\nRES_42001_SAUAJ\nUSA_31042_USACB\n"

	defOrigenIntDestinoInt = "AMM_005511996601301\nCAM_0050660072517\nCAN_0016044741020\nMEX_00525543692618\nMUN_0081188652243\nPRI_0017879992010\nUSA_0012012081010\nEUP_00493021270\nSA1_0087032901234\nSA2_0087434901234\nSA3_0088167098765\nSA4_0087057098765\nSA5_0087078908765\n"

	defOrigenNacDestinoInt = "ALASKA_0019077627000\nALP_005116171000\nAM1_00541148553912\nAM2_00584142391409\nAMM1_005012232302\nAMM2_005072699741\nBHM_0014412971200\nCAM_0050241102002\nCANADA_0016044741020\nCARIBE_0012423029000\nCARIBEAMERICANO_0013407742525\nCENTROAMERICA_002975869000\nCUBA_005358090577\nDEU_00493021270\nEP1_0033951333484\nEP2_00421484199777\nESP_0034615878068\nEUP_0041414190909\nEUROPA_0037797979696\nHAWAII_0018089435800\nISR_0097237536655\nMU1_0078005000774\nMUNDIAL_0093799654000\nPRI_0017879992010\nRDM_0018094121010\nSATELITAL1_0087032901234\nSATELITAL2_0087434901234\nSATELITAL3_0088167098765\nSATELITAL4_0087057098765\nSATELITAL5_0087078908765\nUSA_0012012081010\nINT_0016703223311\n"

	// Solo se usan si no existe datos/headers.txt o datos/new_headers.txt (copiarlos del servidor).
	respaldoHeaders    = "HEADER@OPERADOR\n554369@TELCEL\n"
	respaldoNewHeaders = "554369@1@9999@RADIOMOVIL DIPSA@TELCEL@CDMX@\n"
)

func (g *Gen) rutaDatos(nombre string) string { return filepath.Join(g.base, "datos", nombre) }

func existe(ruta string) bool {
	_, err := os.Stat(ruta)
	return err == nil
}

// leerLineas regresa las lineas del archivo (sin \r de Windows ni la linea vacia final).
func leerLineas(ruta string) ([]string, error) {
	b, err := os.ReadFile(ruta)
	if err != nil {
		return nil, err
	}
	s := strings.ReplaceAll(string(b), "\r", "")
	s = strings.TrimSuffix(s, "\n")
	if s == "" {
		return []string{}, nil
	}
	return strings.Split(s, "\n"), nil
}

func crearSiNoExiste(ruta, contenido string) error {
	if existe(ruta) {
		return nil
	}
	return os.WriteFile(ruta, []byte(contenido), 0o644)
}

// agregarSiFalta agrega la linea al final del archivo si ninguna linea empieza con prefijo.
func agregarSiFalta(ruta, prefijo, linea string, ignorarMayus bool) error {
	b, err := os.ReadFile(ruta)
	if err != nil {
		return err
	}
	for _, l := range strings.Split(strings.ReplaceAll(string(b), "\r", ""), "\n") {
		if strings.HasPrefix(l, prefijo) || (ignorarMayus && strings.HasPrefix(strings.ToUpper(l), strings.ToUpper(prefijo))) {
			return nil
		}
	}
	s := string(b)
	if len(s) > 0 && !strings.HasSuffix(s, "\n") {
		s += "\n"
	}
	return os.WriteFile(ruta, []byte(s+linea+"\n"), 0o644)
}

// prepararArchivos replica la seccion ARCHIVOS de los scripts.
func (g *Gen) prepararArchivos(tipo string) error {
	// Los scripts crean listas por defecto un poco distintas segun si la carpeta datos/ ya
	// existia y segun el script (voz o sms); se replica igual para que los archivos coincidan.
	datosNuevo := !existe(filepath.Join(g.base, "datos"))
	if err := os.MkdirAll(filepath.Join(g.base, "datos"), 0o755); err != nil {
		return err
	}
	matrices, grupos := defMatrices, defOrigenNacDestinoInt
	if (tipo == "voz") != datosNuevo {
		matrices = strings.TrimSuffix(defMatrices, "OCFA_0\n")
	}
	if tipo == "sms" && !datosNuevo {
		grupos = strings.Replace(grupos, "MU1_0078005000774", "MU1_0061362567888", 1)
	}
	archivos := [][2]string{
		{"ultimo_numero_" + tipo + "_nacional.txt", "1\n"},
		{"id_matrices_gprs.txt", matrices},
		{"ejecucion_" + tipo + "_nacional.txt", "0\n"},
		{"origen_nacional_destino_internacional.txt", grupos},
	}
	if tipo == "voz" {
		archivos = append(archivos,
			[2]string{"origen_internacional.txt", defOrigenInternacional},
			[2]string{"origen_internacional_destino_internacional.txt", defOrigenIntDestinoInt})
	}
	for _, a := range archivos {
		if err := crearSiNoExiste(g.rutaDatos(a[0]), a[1]); err != nil {
			return err
		}
	}
	if tipo == "voz" {
		if err := agregarSiFalta(g.rutaDatos("id_matrices_gprs.txt"), "OCZ_", "OCZ_0", false); err != nil {
			return err
		}
	}
	if err := agregarSiFalta(g.rutaDatos("origen_nacional_destino_internacional.txt"), "NLD_", "NLD_0031612345678", true); err != nil {
		return err
	}
	if err := os.MkdirAll(filepath.Join(g.base, "CDR", strings.ToUpper(tipo), "NACIONAL"), 0o755); err != nil {
		return err
	}

	var err error
	if g.grupos, err = leerLineas(g.rutaDatos("origen_nacional_destino_internacional.txt")); err != nil {
		return err
	}
	if g.hd, err = leerLineas(g.rutaDatos("headers.txt")); err != nil {
		g.hd, _ = leerTexto(respaldoHeaders)
		g.aviso("No existe datos/headers.txt: se usa una lista minima de prueba. Copie headers.txt del servidor para generar numeros aleatorios reales.")
	}
	if g.nh, err = leerLineas(g.rutaDatos("new_headers.txt")); err != nil {
		g.nh, _ = leerTexto(respaldoNewHeaders)
		g.aviso("No existe datos/new_headers.txt: se usa una lista minima de prueba. Copie new_headers.txt del servidor para validar numeros de B y estados reales.")
	}
	return nil
}

func leerTexto(s string) ([]string, error) {
	return strings.Split(strings.TrimSuffix(s, "\n"), "\n"), nil
}

func (g *Gen) leerEntero(nombre string) (int, error) {
	b, err := os.ReadFile(g.rutaDatos(nombre))
	if err != nil {
		return 0, err
	}
	n, err := strconv.Atoi(strings.TrimSpace(string(b)))
	if err != nil {
		return 0, fmt.Errorf("el archivo datos/%s no tiene un numero valido", nombre)
	}
	return n, nil
}

func (g *Gen) escribirEntero(nombre string, n int) error {
	return os.WriteFile(g.rutaDatos(nombre), []byte(strconv.Itoa(n)+"\n"), 0o644)
}

// siguienteIDMatriz replica: matriz="OCZ"$(expr $(grep OCZ id_matrices_gprs.txt|awk -F'_' '{print $2}') + 1)
func (g *Gen) siguienteIDMatriz(matriz string) (int, error) {
	lineas, err := leerLineas(g.rutaDatos("id_matrices_gprs.txt"))
	if err != nil {
		return 0, err
	}
	for _, l := range lineas {
		if strings.Contains(l, matriz) {
			campos := strings.Split(l, "_")
			if len(campos) > 1 {
				if n, err := strconv.Atoi(campos[1]); err == nil {
					return n + 1, nil
				}
			}
			break
		}
	}
	return 0, fmt.Errorf("no se encontro el ID de matriz %s en datos/id_matrices_gprs.txt", matriz)
}

// actualizarMatriz replica: sed -e 's/'$matriz'_/'$id_final'_/g' id_matrices_gprs.txt
func (g *Gen) actualizarMatriz(matriz, idFinal string) error {
	ruta := g.rutaDatos("id_matrices_gprs.txt")
	b, err := os.ReadFile(ruta)
	if err != nil {
		return err
	}
	s := strings.ReplaceAll(string(b), matriz+"_", idFinal+"_")
	s = strings.TrimRight(s, "\n") + "\n"
	return os.WriteFile(ruta, []byte(s), 0o644)
}

func (g *Gen) agregarLineas(rel string, lineas []string) error {
	if len(lineas) == 0 {
		return nil
	}
	f, err := os.OpenFile(filepath.Join(g.base, rel), os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0o644)
	if err != nil {
		return err
	}
	defer f.Close()
	_, err = f.WriteString(strings.Join(lineas, "\n") + "\n")
	return err
}
