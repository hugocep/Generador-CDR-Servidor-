#!/bin/bash
# Pruebas de los scripts corregidos y del generador Go (el .exe usa el mismo codigo).
#
#  1. Casos de roaming que antes fallaban: se revisan los campos clave del CDR.
#  2. Regresion: casos que ya funcionaban dan exactamente la misma salida que el script original.
#  3. El generador Go da exactamente la misma salida que los scripts bash corregidos.
#
# Uso: bash pruebas/probar.sh     (desde la raiz del repositorio; requiere bash, Go y git)
# Los numeros de datos_prueba/ son ficticios, solo para pruebas.

REPO=$(cd "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
A=5512345678; I=334020123456789
fallas=0
ok(){ echo "  OK   $1"; }
mal(){ echo "  FALLA $1"; fallas=$((fallas+1)); }

prep(){ # prep <dir> <datos_prueba>
rm -rf "$1"; mkdir -p "$1/datos"; cp "$2"/*.txt "$1/datos/"
cp "$REPO/servidor/new_voz_nacional_campos.sh" "$1/voz.sh"; cp "$REPO/servidor/new_sms_nacional_campos.sh" "$1/sms.sh"
}
campo(){ cut -d'|' -f"$1" <<< "$2"; }

echo "== Compilando generador Go"
(cd "$REPO/cdrgen" && go build -o "$TMP/cdrgen" .) || { echo "no compila"; exit 1; }

########################################################################################
echo "== 1. Casos de roaming (scripts corregidos)"
prep "$TMP/r" "$REPO/pruebas/datos_prueba"; cd "$TMP/r"
bash voz.sh 28/09/2026 1 $A $I "+31 6 1234 5678" - SALIENTE 10:00:00 10:05:00 - NORMAL n 31653131232 </dev/null >/dev/null 2>&1
l=$(tail -1 CDR/VOZ/NACIONAL/*.unl 2>/dev/null)
[ "$(campo 4 "$l")" == "0031612345678" ] && [ "$(campo 13 "$l")" == "31653131232" ] && ok "voz saliente en Paises Bajos a +31: B=0031..., VLR campo 13" || mal "voz roaming saliente: $l"
bash voz.sh 28/09/2026 1 $A $I 004915112345678 - ENTRANTE 10:10:00 10:12:00 - NORMAL n 31653131232 </dev/null >/dev/null 2>&1
l=$(tail -1 CDR/VOZ/NACIONAL/*.unl)
[ "$(campo 3 "$l")" == "004915112345678" ] && [ "$(campo 15 "$l")" == "31653131232" ] && ok "voz entrante en Paises Bajos desde +49: VLR campo 15" || mal "voz roaming entrante: $l"
bash sms.sh 28/09/2026 1 $A $I 0031612345678 - ENTRANTE 10:00:00 - NORMAL n - 491770610000 </dev/null >/dev/null 2>&1
l=$(tail -1 CDR/SMS/NACIONAL/*.unl)
[ "$(campo 8 "$l")" == "0031612345678" ] && [ "$(campo 58 "$l")" == "491770610000" ] && ok "sms entrante de +31 estando en Alemania: origen 0031... (antes 0052...)" || mal "sms roaming entrante: $l"
bash sms.sh 28/09/2026 1 $A $I 4915112345678 CDMX ENTRANTE 10:00:10 - NORMAL n - +31653131232 </dev/null >/dev/null 2>&1
l=$(tail -1 CDR/SMS/NACIONAL/*.unl)
[ "$(campo 8 "$l")" == "004915112345678" ] && [ "$(campo 58 "$l")" == "31653131232" ] && ok "sms entrante de 49... estando en Paises Bajos (VLR con +)" || mal "sms roaming entrante 2: $l"
bash sms.sh 28/09/2026 1 $A $I - NLD ENTRANTE 10:00:20 - NORMAL n - 491770610000 </dev/null >/dev/null 2>&1
l=$(tail -1 CDR/SMS/NACIONAL/*.unl)
[ "$(campo 8 "$l")" == "0031612345678" ] && ok "sms entrante con destino NLD y B aleatorio" || mal "sms NLD: $l"
out=$(timeout 20 bash sms.sh 28/09/2026 1 $A $I 3312345678 JALISCO SALIENTE 10:00:00 - XYZ n - - </dev/null 2>&1); rc=$?
[ $rc -eq 1 ] && ok "parametro invalido termina con error (antes se ciclaba o generaba basura)" || mal "parametro invalido rc=$rc"
out=$(timeout 20 bash voz.sh 28/09/2026 1 $A $I 3312345678 JALISCO SALIENTE 10:00:00 10:00:00 - NORMAL n </dev/null 2>&1); rc=$?
[ $rc -ne 124 ] && ok "voz con hora inicial = final no se cicla" || mal "voz se cicla con horas iguales"
out=$(timeout 20 bash voz.sh 15/03/2027 1 $A $I 3312345678 JALISCO SALIENTE 10:00:00 10:01:00 - NORMAL n </dev/null 2>&1); rc=$?
grep -q '|20270315100000|' CDR/VOZ/NACIONAL/*.unl && ok "acepta fechas de 2027 (antes el año maximo era 2026)" || mal "fecha 2027 rc=$rc"

########################################################################################
echo "== 2. Regresion contra el script original (casos que ya funcionaban)"
casos_voz=(
"28/09/2026 1 $A $I 3312345678 JALISCO SALIENTE 10:00:00 10:05:00 - NORMAL n"
"28/09/2026 3 $A $I 3312345678 JALISCO ENTRANTE 10:00:00 10:30:00 - NORMAL n"
"28/09/2026 1 $A $I 5543691234 CDMX SALIENTE 23:59:00 00:02:00 - NORMAL n"
"28/09/2026 1 $A $I 0031612345678 EUROPA SALIENTE 10:00:00 10:05:00 - NORMAL n"
"28/09/2026 1 $A $I 0049301234567 DEU ENTRANTE 10:00:00 10:05:00 - NORMAL n"
"28/09/2026 1 $A $I 030 CDMX SALIENTE 10:00:00 10:01:00 - CORTA n"
"28/09/2026 1 $A $I 3312345678 JALISCO SALIENTE 10:00:00 10:01:00 - PORCOBRAR n"
"28/09/2026 1 $A $I 3312345678 JALISCO ENTRANTE 10:00:00 10:01:00 - PORCOBRAR n"
"28/09/2026 1 $A $I 3312345678 JALISCO PATROCINADA 10:00:00 10:01:00 - PORCOBRAR n"
"28/09/2026 1 $A $I 3312345678 JALISCO SALIENTE 10:00:00 10:01:00 - VIDEOLLAMADA n"
"28/09/2026 2 $A $I 3312345678 JALISCO SALIENTE 10:00:00 10:01:00 PRUEBA77 NORMAL y"
"28/09/2026 1 $A $I 3312345678 NUEVOLEON SALIENTE 10:00:00 10:01:00 - NORMAL n"
"28/09/2026 1 $A $I 00525512345678 MUNDIAL SALIENTE 10:00:00 10:01:00 - NORMAL n"
"28/09/2026 1 $A $I *264 CDMX SALIENTE 10:00:00 10:01:00 - CORTA n"
"28/09/2026 1 $A $I 3312345678 JALISCO SALIENTE 10:00:00 10:01:00 - normal n"
)
casos_sms=(
"28/09/2026 1 $A $I 3312345678 JALISCO SALIENTE 10:00:00 - NORMAL n - -"
"28/09/2026 2 $A $I 3312345678 JALISCO ENTRANTE 10:00:00 - NORMAL n - -"
"28/09/2026 1 $A $I 0031612345678 EUROPA SALIENTE 10:00:00 - NORMAL n - -"
"28/09/2026 1 $A $I 0031612345678 EUROPA ENTRANTE 10:00:00 - NORMAL n - 491770610000"
"28/09/2026 1 $A $I 0049301234567 DEU SALIENTE 10:00:00 - NORMAL n - 31653131232"
"28/09/2026 1 $A $I - DEU ENTRANTE 10:00:00 - NORMAL n - 31653131232"
"28/09/2026 1 $A $I - DEU SALIENTE 10:00:00 - NORMAL n - -"
"28/09/2026 1 $A $I 030 CDMX SALIENTE 10:00:00 - CORTA n - -"
"28/09/2026 1 $A $I 3312345678 JALISCO SALIENTE 10:00:00 - PORCOBRAR n - -"
"28/09/2026 1 $A $I 3312345678 JALISCO SALIENTE 10:00:00 - NORMAL n RP -"
"28/09/2026 1 $A $I 3312345678 JALISCO SALIENTE 10:00:00 - NORMAL n - 5294100000999"
"28/09/2026 1 $A $I 3312345678 JALISCO ENTRANTE 10:00:00 SMS99 NORMAL y - 5294100000999"
"28/09/2026 1 $A $I 00525512345678 MUNDIAL ENTRANTE 10:00:00 - NORMAL n - -"
"28/09/2026 1 $A $I *264 CDMX SALIENTE 10:00:00 - CORTA n - -"
"28/09/2026 1 $A $I 5543691234 CDMX ENTRANTE 10:00:00 - NORMAL n RP -"
)
prep "$TMP/o" "$REPO/pruebas/datos_prueba"; prep "$TMP/f" "$REPO/pruebas/datos_prueba"
(cd "$REPO" && git show 7e7f010:servidor/new_voz_nacional_campos.sh) > "$TMP/o/voz.sh"
(cd "$REPO" && git show 7e7f010:servidor/new_sms_nacional_campos.sh) > "$TMP/o/sms.sh"
for d in o f; do (cd "$TMP/$d"; bash sms.sh 01/01/2020 1 $A $I 3312345678 JALISCO SALIENTE 00:00:00 - NORMAL n - - </dev/null >/dev/null 2>&1
 grep -q ^OCZ_ datos/id_matrices_gprs.txt || echo OCZ_0 >> datos/id_matrices_gprs.txt
 grep -q ^NLD_ datos/origen_nacional_destino_internacional.txt || echo NLD_0031612345678 >> datos/origen_nacional_destino_internacional.txt
 rm -rf CDR; mkdir -p CDR/SMS/NACIONAL CDR/VOZ/NACIONAL); done
for c in "${casos_voz[@]}"; do for d in o f; do (cd "$TMP/$d"; timeout 20 bash voz.sh $c </dev/null >/dev/null 2>&1); done; done
for c in "${casos_sms[@]}"; do for d in o f; do (cd "$TMP/$d"; timeout 20 bash sms.sh $c </dev/null >/dev/null 2>&1); done; done
n=$(cat "$TMP"/o/CDR/*/NACIONAL/* | wc -l)
diff -r "$TMP/o/CDR" "$TMP/f/CDR" >/dev/null && [ $n -gt 20 ] && ok "$n CDRs identicos al script original" || mal "la salida cambio respecto al original"
diff "$TMP/o/datos/id_matrices_gprs.txt" "$TMP/f/datos/id_matrices_gprs.txt" >/dev/null && ok "contadores de ID de matriz identicos" || mal "contadores de matriz distintos"

########################################################################################
echo "== 3. Generador Go (.exe) vs scripts bash corregidos"
comparar(){ # comparar <datos_prueba> <nombre> casos...
local dp=$1 nom=$2; shift 2
prep "$TMP/b" "$dp"; rm -rf "$TMP/g"; mkdir -p "$TMP/g"; cp -r "$TMP/b/datos" "$TMP/g/"
local c t
for c in "$@"; do t=${c%% *}; c=${c#* }
 (cd "$TMP/b"; timeout 20 bash $t.sh $c </dev/null >/dev/null 2>&1); rb=$?
 "$TMP/cdrgen" -dir "$TMP/g" $t $c >/dev/null 2>&1; rg=$?
 if [ $rb -eq 0 ] && [ $rg -ne 0 ] || [ $rb -ne 0 ] && [ $rg -eq 0 ]; then echo "     distinto codigo de salida ($rb/$rg): $t $c"; fi
done
if diff -r "$TMP/b/CDR" "$TMP/g/CDR" >/dev/null && diff -r "$TMP/b/datos" "$TMP/g/datos" >/dev/null; then
 ok "$nom: $(cat "$TMP"/b/CDR/*/NACIONAL/* 2>/dev/null | wc -l) CDRs y archivos de datos identicos"
else mal "$nom"; diff -r "$TMP/b/CDR" "$TMP/g/CDR" | head -8; diff -r "$TMP/b/datos" "$TMP/g/datos" | head -8; fi
}
todos=()
for c in "${casos_voz[@]}"; do todos+=("voz $c"); done
for c in "${casos_sms[@]}"; do todos+=("sms $c"); done
todos+=(
"voz 28/09/2026 1 $A $I 0031612345678 - SALIENTE 10:00:00 10:05:00 - NORMAL n 31653131232"
"voz 28/09/2026 1 $A $I +31612345678 CDMX SALIENTE 10:00:00 10:05:00 - NORMAL n +31653131232"
"voz 28/09/2026 2 $A $I 004915112345678 - ENTRANTE 10:30:00 10:32:00 - NORMAL n 31653131232"
"voz 28/09/2026 1 $A $I - NLD SALIENTE 11:20:00 11:21:00 - NORMAL n 31653131232"
"voz 28/09/2026 1 $A $I 3312345678 - SALIENTE 11:10:00 11:11:00 - NORMAL n"
"voz 28/09/2026 1 $A $I 030 - SALIENTE 11:30:00 11:31:00 - CORTA n"
"voz 28/09/2026 1 $A $I 3312345678 - SALIENTE 11:40:00 11:41:00 - XYZ n"
"voz 28/09/2026 1 $A $I 1234567890 - SALIENTE 11:40:00 11:41:00 - NORMAL n"
"voz 28/09/2026 1 $A $I 3312345678 CDMXX SALIENTE 11:40:00 11:41:00 - NORMAL n"
"voz 28/09/2026 1 $A $I 3312345678 DEU SALIENTE 11:40:00 11:41:00 - NORMAL n"
"voz 28/09/2026 1 $A $I 3312345678 JALISCO OTRO 11:40:00 11:41:00 - NORMAL n"
"voz 28/09/2026 1 $A 12345 3312345678 JALISCO SALIENTE 11:40:00 11:41:00 - NORMAL n"
"voz 31/02/2026 1 $A $I 3312345678 JALISCO SALIENTE 11:40:00 11:41:00 - NORMAL n"
"voz 28/09/2026 1 $A $I 3312345678 JALISCO SALIENTE 11:40:00 11:40:00 - NORMAL n"
"voz 15/03/2027 5 $A $I +52 33 1234 5678 JALISCO SALIENTE 11:40:00 12:41:07 - NORMAL y"
"sms 28/09/2026 1 $A $I 0031612345678 - ENTRANTE 10:00:00 - NORMAL n - 491770610000"
"sms 28/09/2026 3 $A $I 4915112345678 CDMX ENTRANTE 10:00:10 - NORMAL n - +31653131232"
"sms 28/09/2026 1 $A $I - NLD ENTRANTE 10:00:20 - NORMAL n - 491770610000"
"sms 28/09/2026 1 $A $I 004915112345678 - SALIENTE 10:00:50 - NORMAL n - 31653131232"
"sms 28/09/2026 1 $A $I 3312345678 - SALIENTE 10:01:10 - NORMAL n - -"
"sms 28/09/2026 1 $A $I 030 - SALIENTE 10:01:30 - CORTA n - -"
"sms 28/09/2026 1 $A $I 3312345678 JALISCO SALIENTE 10:00:00 - XYZ n - -"
"sms 28/09/2026 1 $A $I 3312345678 JALISCO SALIENTE - - NORMAL n - -"
"sms 28/09/2026 1 $A $I 3312345678 DEU SALIENTE 10:00:00 - NORMAL n - -"
)
comparar "$REPO/pruebas/datos_prueba" "casos deterministas" "${todos[@]}"

# numeros aleatorios deterministas: un solo header de 10 digitos por lista
mkdir -p "$TMP/dp2"
printf 'HEADER@OPERADOR\n5543691234@TELCEL\n' > "$TMP/dp2/headers.txt"
printf '3312345678@1@9999@RADIOMOVIL DIPSA@TELCEL@JALISCO@X\n' > "$TMP/dp2/new_headers.txt"
comparar "$TMP/dp2" "casos con B aleatorio" \
"voz 28/09/2026 1 $A $I - - SALIENTE 10:00:00 10:05:00 - NORMAL n" \
"voz 28/09/2026 2 $A $I - JALISCO ENTRANTE 10:00:00 10:05:00 - NORMAL n" \
"voz 28/09/2026 1 $A $I - - SALIENTE 10:00:00 10:05:00 - PORCOBRAR n" \
"voz 28/09/2026 1 $A $I - JALISCO ENTRANTE 10:00:00 10:05:00 - PORCOBRAR n" \
"sms 28/09/2026 2 $A $I - - ENTRANTE 10:00:00 - NORMAL n - 491770610000" \
"sms 28/09/2026 1 $A $I - JALISCO ENTRANTE 10:00:00 - NORMAL n - -" \
"sms 28/09/2026 1 $A $I - - SALIENTE 10:00:00 - NORMAL n RP -" \
"sms 28/09/2026 1 $A $I - JALISCO SALIENTE 10:00:00 - PORCOBRAR n - -" \
"sms 28/09/2026 1 $A $I - - SALIENTE 10:00:00 - PORCOBRAR n - -"

echo
if [ $fallas -eq 0 ]; then echo "TODAS LAS PRUEBAS PASARON"; else echo "$fallas PRUEBA(S) FALLARON"; exit 1; fi
