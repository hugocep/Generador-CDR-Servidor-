#!/bin/bash

#echo $1 
#echo $2 
#echo $3 
#echo $4 
#echo $5 
#echo $6 
#echo $7 
#echo $8 
#echo $9 
#echo ${10}
#echo ${11}
#
#read lp

############################################################################################################################################
#------------------------------------------------------------------ARCHIVOS----------------------------------------------------------------#
############################################################################################################################################

if [ ! -e datos ]
then
mkdir datos
echo "1" > ./datos/ultimo_numero_voz_nacional.txt
echo -e "OCA_0\nOCB_0\nOCC_0\nOCD_0\nOCE_0\nOCF_0\nOCG_0\nOCH_0\nOCI_0\nOCJ_0\nSCA_0\nSCB_0\nSCC_0\nSCD_0\nSCE_0\nSCF_0\nSCG_0\nSCH_0\nSCI_0\nSCJ_0\nSCK_0\nSCL_0\nSCM_0\nSCN_0\nSCO_0\nSCP_0\nSCQ_0\nSCR_0\nSCS_0\nSCT_0\nSCU_0\nSCV_0\nSCW_0\nSCX_0\nRCA_0\nRCB_0\nRCC_0\nRCD_0\nRCE_0\nRCF_0\nRCG_0\nRCH_0\nRCI_0\nRCJ_0\nRCK_0\nRCL_0\nRCM_0\nRCN_0\nRCO_0\nRCP_0\nRCQ_0\nRCR_0\nRCS_0\nRCT_0\nRCU_0\nRCV_0\nRCW_0\nRCX_0\nRCY_0\nRCZ_0\nRCZA_0\nRCZB_0\nRCZC_0\nRCZD_0\nRCZE_0\nRCZF_0\nFCA_0\nFCB_0\nFCC_0\nFCD_0\nFCE_0\nFCF_0\nOCFA_0" > ./datos/id_matrices_gprs.txt
echo -e "ACA_73001_CHLMV\nACB_37002_DOMCL\nASA_72231_ARGCM\nCAN_30261_CANBM\nCUB_36801_CUB01\nEUP_26201_DEUD1\nGUA_70402_GTMCM\nMA2_90112_NORMC\nMAR_90118_BMU01\nMUN_33807_JAMCL\nPEF_20822_FRATR\nPRI_33011_PRICL\nR2A_42507_ISRMS\nRE1_25001_RUS01\nRE2_36011_VCTCW\nREB_64801_ZWEN1\nREC_73406_VENMV\nRES_42001_SAUAJ\nUSA_31042_USACB" > ./datos/origen_internacional.txt
echo -e "AMM_005511996601301\nCAM_0050660072517\nCAN_0016044741020\nMEX_00525543692618\nMUN_0081188652243\nPRI_0017879992010\nUSA_0012012081010\nEUP_00493021270\nSA1_0087032901234\nSA2_0087434901234\nSA3_0088167098765\nSA4_0087057098765\nSA5_0087078908765" > ./datos/origen_internacional_destino_internacional.txt
echo -e "ALASKA_0019077627000\nALP_005116171000\nAM1_00541148553912\nAM2_00584142391409\nAMM1_005012232302\nAMM2_005072699741\nBHM_0014412971200\nCAM_0050241102002\nCANADA_0016044741020\nCARIBE_0012423029000\nCARIBEAMERICANO_0013407742525\nCENTROAMERICA_002975869000\nCUBA_005358090577\nDEU_00493021270\nEP1_0033951333484\nEP2_00421484199777\nESP_0034615878068\nEUP_0041414190909\nEUROPA_0037797979696\nHAWAII_0018089435800\nISR_0097237536655\nMU1_0078005000774\nMUNDIAL_0093799654000\nPRI_0017879992010\nRDM_0018094121010\nSATELITAL1_0087032901234\nSATELITAL2_0087434901234\nSATELITAL3_0088167098765\nSATELITAL4_0087057098765\nSATELITAL5_0087078908765\nUSA_0012012081010\nINT_0016703223311" > ./datos/origen_nacional_destino_internacional.txt
echo "0" > ./datos/ejecucion_voz_nacional.txt
fi

if [ ! -f ./datos/ultimo_numero_voz_nacional.txt ]
then
echo "1" > ./datos/ultimo_numero_voz_nacional.txt
fi

if [ ! -f ./datos/id_matrices_gprs.txt ]
then
echo -e "OCA_0\nOCB_0\nOCC_0\nOCD_0\nOCE_0\nOCF_0\nOCG_0\nOCH_0\nOCI_0\nOCJ_0\nSCA_0\nSCB_0\nSCC_0\nSCD_0\nSCE_0\nSCF_0\nSCG_0\nSCH_0\nSCI_0\nSCJ_0\nSCK_0\nSCL_0\nSCM_0\nSCN_0\nSCO_0\nSCP_0\nSCQ_0\nSCR_0\nSCS_0\nSCT_0\nSCU_0\nSCV_0\nSCW_0\nSCX_0\nRCA_0\nRCB_0\nRCC_0\nRCD_0\nRCE_0\nRCF_0\nRCG_0\nRCH_0\nRCI_0\nRCJ_0\nRCK_0\nRCL_0\nRCM_0\nRCN_0\nRCO_0\nRCP_0\nRCQ_0\nRCR_0\nRCS_0\nRCT_0\nRCU_0\nRCV_0\nRCW_0\nRCX_0\nRCY_0\nRCZ_0\nRCZA_0\nRCZB_0\nRCZC_0\nRCZD_0\nRCZE_0\nRCZF_0\nFCA_0\nFCB_0\nFCC_0\nFCD_0\nFCE_0\nFCF_0" > ./datos/id_matrices_gprs.txt
fi

if [ ! -f ./datos/ejecucion_voz_nacional.txt ]
then
echo "0" > ./datos/ejecucion_voz_nacional.txt
fi

if [ ! -f ./datos/origen_internacional.txt ]
then
echo -e "ACA_73001_CHLMV\nACB_37002_DOMCL\nASA_72231_ARGCM\nCAN_30261_CANBM\nCUB_36801_CUB01\nEUP_26201_DEUD1\nGUA_70402_GTMCM\nMA2_90112_NORMC\nMAR_90118_BMU01\nMUN_33807_JAMCL\nPEF_20822_FRATR\nPRI_33011_PRICL\nR2A_42507_ISRMS\nRE1_25001_RUS01\nRE2_36011_VCTCW\nREB_64801_ZWEN1\nREC_73406_VENMV\nRES_42001_SAUAJ\nUSA_31042_USACB" > ./datos/origen_internacional.txt
fi

if [ ! -f ./datos/origen_internacional_destino_internacional.txt ]
then
echo -e "AMM_005511996601301\nCAM_0050660072517\nCAN_0016044741020\nMEX_00525543692618\nMUN_0081188652243\nPRI_0017879992010\nUSA_0012012081010\nEUP_00493021270\nSA1_0087032901234\nSA2_0087434901234\nSA3_0088167098765\nSA4_0087057098765\nSA5_0087078908765" > ./datos/origen_internacional_destino_internacional.txt
fi

if [ ! -f ./datos/origen_nacional_destino_internacional.txt ]
then
echo -e "ALASKA_0019077627000\nALP_005116171000\nAM1_00541148553912\nAM2_00584142391409\nAMM1_005012232302\nAMM2_005072699741\nBHM_0014412971200\nCAM_0050241102002\nCANADA_0016044741020\nCARIBE_0012423029000\nCARIBEAMERICANO_0013407742525\nCENTROAMERICA_002975869000\nCUBA_005358090577\nDEU_00493021270\nEP1_0033951333484\nEP2_00421484199777\nESP_0034615878068\nEUP_0041414190909\nEUROPA_0037797979696\nHAWAII_0018089435800\nISR_0097237536655\nMU1_0078005000774\nMUNDIAL_0093799654000\nPRI_0017879992010\nRDM_0018094121010\nSATELITAL1_0087032901234\nSATELITAL2_0087434901234\nSATELITAL3_0088167098765\nSATELITAL4_0087057098765\nSATELITAL5_0087078908765\nUSA_0012012081010\nINT_0016703223311" > ./datos/origen_nacional_destino_internacional.txt
fi

if [ ! -e CDR ];then mkdir CDR;fi

if [ ! -e ./CDR/VOZ/NACIONAL ];then mkdir -p ./CDR/VOZ/NACIONAL;fi

############################################################################################################################################
#-----------------------------------------------------------------FUNCIONES----------------------------------------------------------------#
############################################################################################################################################

mesAnumeros () #transforma el mes de letras a numeros
{
mes=`echo $1`

case $mes in
Jan|jan|ene)
mes=01;;
Feb|feb)
mes=02;;
Mar|mar)
mes=03;;
Apr|apr|abr)
mes=04;;
May|may)
mes=05;;
Jun|jun)
mes=06;;
Jul|jul)
mes=07;;
Aug|aug|ago)
mes=08;;
Sep|sep)
mes=09;;
Oct|oct)
mes=10;;
Nov|nov)
mes=11;;
Dec|dec|dic)
mes=12;;
*)
mes="error";;
esac

echo $mes
}

mesAletras ()  #transforma el mes de numero a letras
{
mes=`echo $1| awk -F'/' '{print $2}'`

case $mes in 
1|01)
mes=Jan;;
2|02)
mes=Feb;;
3|03)
mes=Mar;;
4|04)
mes=Apr;;
5|05)
mes=May;;
6|06)
mes=Jun;;
7|07)
mes=Jul;;
8|08)
mes=Aug;;
9|09)
mes=Sep;;
10)
mes=Oct;;
11)
mes=Nov;;
12)
mes=Dec;;
*)
mes="error";;
esac

echo $mes
}

fechaCalendario () #esta funcion verifica si la fecha ingresada existe en el calendario
{
dia=$(echo $1 | awk -F'/' '{print $1}');
mes=$(mesAletras $1);
anio=$(echo $1 | awk -F'/' '{print $3}');

date -d "$dia $mes $anio" >/dev/null 2>&1
validacionCalendario=$(echo $?)
if [ $validacionCalendario != 0 ]
then
echo "1"
else
echo "0"
fi
}

validaFecha () #valida si la fecha ingresada es correcta
{

cadenavalida=$(echo $1|grep -E '^[[:digit:]]{1,2}\/[[:digit:]]{1,2}\/[[:digit:]]{4,4}$' >/dev/null;echo $?)
cantidadvalida=$(echo $1|awk -F'/' '{if($1>31 || $1<0) print "dia_error"; else if($2>12 || $2<0 ) print "mes_error"; else if ($3>2026 || $3<1990)print "año_error"; else print "0"}')
valFechaCalendario=$(fechaCalendario $1)

if [ $cadenavalida != 0 ] || [ $cantidadvalida != 0 ] || [ $valFechaCalendario != 0 ]
then
echo "1"
else 
echo "0"
fi

}

validaTiempo () #valida si la hora ingresada es correcta
{

cadenavalida=$(echo $1| grep -E '^[[:digit:]]{1,2}:[[:digit:]]{1,2}:[[:digit:]]{1,2}$' >/dev/null;echo $?)
cantidadvalida=$(echo $1|awk -F':' '{if($1>23 || $1<0) print "horas_error"; else if($2>59 || $2<0 ) print "minutos_error"; else if ($3>59 || $3<0)print "segundos_error"; else print "0"}')

if [ $cadenavalida != 0 ] || [ $cantidadvalida != 0 ]
then
echo "1"
else 
echo "0"
fi

}

formatoFecha () #tranforma de una fecha de numeros al formato que acepta el comando date
{
dia=$(echo $1 | awk -F'/' '{print $1}');
mes=$(mesAletras $1);
anio=$(echo $1 | awk -F'/' '{print $3}');
echo "$dia $mes $anio"
}

redondeoUp () #redondea cualquier numero que tenga decimales desde .1 o .0001
{
cantidadEnbytes=$(echo "$1*$2" | bc)
decimales=`echo "$cantidadEnbytes"| grep -Eo '\.[0-9]*'| tr -d '\.'`
echo "$cantidadEnbytes"|grep -o '\.'>/dev/null
valida_decimales=$(echo $?)
#Aqui redondeo el numero tal cual lo hace el excel
if [ $valida_decimales -eq 0 ] && [ $decimales -ne 0 ] #si tiene un punto decimal y los decimales son diferentes de cero le sumo uno
then
cantidadEnbytes=$(echo "$cantidadEnbytes+1"| bc)
echo "$cantidadEnbytes"| grep -Eo '[0-9]*\.' | tr -d '\.'
else
printf "%.0f" $cantidadEnbytes
fi
}

<<origen_internacional
validaDestino () #Valida el grupo de destino internacional
{
awk -F'_' '{print $1}' ./datos/origen_internacional_destino_internacional.txt|grep -E '^'$1'$' >/dev/null
echo $?
}
origen_internacional

validaDestino () #Valida el grupo de destino internacional
{
awk -F'_' '{print $1}' ./datos/origen_nacional_destino_internacional.txt|grep -E '^'"$1"'$' >/dev/null
echo $?
}

validaOrigen () #Valida el grupo de origen internacional
{
awk -F'_' '{print $1}' ./datos/origen_internacional.txt|grep -E '^'"$1"'$' >/dev/null
echo $?
}

validaMatriz () #valida el id de la matriz
{
grep -E '^'$1'_' ./datos/id_matrices_gprs.txt >/dev/null
echo $?
}

###############################################################################
#------------DETERMINO SI SE VA A CREAR UN NUEVO ARCHIVO DE SALIDA------------#
###############################################################################

#echo -e "\n\n###ESTE SCRIPT GENERA CASOS DE TRAFICO PARA EL CDR DE VOZ NACIONAL###\n"


#read -p "Desea generar un nuevo archivo de salida?(y/n): " respuesta_arch
respuesta_arch=${12}
if [ "$respuesta_arch" == "y" ] || [ "$respuesta_arch" == "Y" ] || [ "$respuesta_arch" == "S" ] || [ "$respuesta_arch" == "s" ] || [ $((`cat ./datos/ultimo_numero_voz_nacional.txt`-1)) -eq 100000 ]
then
#echo "0" > ./datos/limite_id_matriz_gprs.txt #reseteo el limite de los id de la matriz a cero ya que es un nuevo archivo

if [ $((`cat ./datos/ultimo_numero_voz_nacional.txt`-1)) -eq 100000 ] #Verifica que el archivo tenga menos de 100mil registros
then
echo -e "\nAdvertencia\nEl archivo llego al maximo de registros, se generará un nuevo archivo"
fi

num_archivos=$(($(cat ./datos/ejecucion_voz_nacional.txt)+1))
numero_linea=1
limite_archivo_anterior=0
else

numero_linea=`cat ./datos/ultimo_numero_voz_nacional.txt`
limite_archivo_anterior=$(($numero_linea-1))
num_archivos=`cat ./datos/ejecucion_voz_nacional.txt`

if [ $(cat ./datos/ejecucion_voz_nacional.txt) == 0 ] # Verifico si es la primera ejecucion del script
then
limite_archivo_anterior=0
num_archivos=1
numero_linea=1
#echo "0" > ./datos/limite_id_matriz_gprs.txt #reseteo a cero los id de matriz cuando es la primera ejecucion del shell
fi

fi
#echo "-----------------------------------------------"
#

<<desa
###############################################################################
#------------------------DETERMINO EL GRUPO DE ORIGEN-------------------------#
###############################################################################
read -p "Ingrese el grupo de Origen Internacional: " origen
while [ $(validaOrigen $origen) != 0 ]
do
echo "Grupo incorrecto"
read -p "Ingrese el grupo de Origen Internacional: " origen
done
echo -e "\n-----------------------------\n"
nombre_carrier=$(grep -E "^$origen" ./datos/origen_internacional.txt| awk -F'_' '{print $3}')

###############################################################################
#------------------------DETERMINO EL GRUPO DE DESTINO------------------------#
###############################################################################
read -p "Ingrese el grupo del Destino Internacional: " destino
while [ $(validaDestino $destino) != 0 ]
do
echo "Grupo incorrecto"
read -p "Ingrese el grupo del Destino Internacional: " destino
done
echo -e "\n-----------------------------\n"
#var9_sms=$(grep -E "^$destino" ./datos/origen_nacional_destino_internacional.txt | awk -F'_' '{print $2}')
desa

###############################################################################
#-------------DETERMINO SI EL DESTINO ES NACIONAL O INTERNACIONAL-------------#
###############################################################################


####MOD 4-6-2020### 
#valido el destino del parametro 6



edo=$6
                
if [ "$(grep -Eo "^$(echo $5|grep -Eo '^.....')@" ./datos/new_headers.txt)" != "" ]
then
cont_b_only=$(grep -Eo "^$(echo $5|grep -Eo '^.....')@" ./datos/new_headers.txt|tr -d '@')
#echo $cont_b_only
if [ "$edo" == "" ]
then

#edo=$(awk -F'@' '{print $6}' ./datos/new_headers.txt |grep -Eio "$edo"|uniq)
edo=$(grep -E "$cont_b_only" ./datos/new_headers.txt|awk -F'@' '{print $6}' )
fi
opcion="Nacional"
op="NORMAL"

fi

if [ "$(grep -Eo "^$(echo $5|grep -Eo '^......')@" ./datos/new_headers.txt)" != "" ]
then
cont_b_only=$(grep -Eo "^$(echo $5|grep -Eo '^......')@" ./datos/new_headers.txt|tr -d '@')
#echo $cont_b_only
if [ "$edo" == "" ]
then
#edo=$(awk -F'@' '{print $6}' ./datos/new_headers.txt |grep -Eio "$edo"|uniq)
edo=$(grep -E "$cont_b_only" ./datos/new_headers.txt|awk -F'@' '{print $6}' )
fi
opcion="Nacional"
op="NORMAL"

fi

if [ "$(grep -Eo "^$(echo $5|grep -Eo '^.......')@" ./datos/new_headers.txt)" != "" ]
then
cont_b_only=$(grep -Eo "^$(echo $5|grep -Eo '^.......')@" ./datos/new_headers.txt|tr -d '@')
#echo $cont_b_only
if [ "$edo" == "" ]
then
#edo=$(awk -F'@' '{print $6}' ./datos/new_headers.txt |grep -Eio "$edo"|uniq)
edo=$(grep -E "$cont_b_only" ./datos/new_headers.txt|awk -F'@' '{print $6}' )
fi
opcion="Nacional"
op="NORMAL"


fi

cont_edo=$(grep -Ei "@$edo@" ./datos/new_headers.txt|wc -l)
cont_pais=$(grep -Eio "$edo" ./datos/origen_nacional_destino_internacional.txt)

cont_b_in_edo=$(grep -Ei "@$edo@" ./datos/new_headers.txt|grep -Eo "^$cont_b_only@")

cont_internacional=$(echo $5|grep -Eo '^00')


#echo "-"$cont_b_in_edo"-"

if [ "$edo" == "" ] && [ "$5" == "-" ]
then
		opcion="Nacional"
fi

if [ "$5" == "-" ] && [ $cont_edo != 0 ]
then
		opcion="Nacional"
fi

if [ "$cont_b_in_edo" != "" ] && [ $(awk -v b=$5 'BEGIN{print length(b)}') == 10 ]
then
		opcion="Nacional"
fi

if [ "$cont_b_only" != "" ] && [ "$edo" == "" ] && [ $(awk -v b=$5 'BEGIN{print length(b)}') == 10 ]
then
		opcion="Nacional"
fi

if [ "$cont_b_in_edo" == "" ] && [ "$5" != "-" ] && [ "$cont_b_only" == "" ] && [ "$cont_internacional" != "00" ] && [ "${11}" != "CORTA" ]
then
echo "---"$cont_internacional
echo entre al 1
echo $5
		echo "Verifique el numero de B"
		echo "----------EXIT----------"
		exit
fi

if [ $cont_edo == 0 ] && [ "$edo" != "" ] && [ "$5" != "-" ] && [ "$cont_pais" == "" ]
then
echo entre al 2
		echo "Verifique el Destino"
		echo "--------EXIT--------"
		exit
fi

if [ "$cont_b_in_edo" == "" ] && [ "$edo" == "" ] && [ "$5" != "-" ]
then
echo "Verifique el Numero/Destino de B"
echo "-----------EXIT------------"
exit
fi

#if [ "$cont_b_only" == "" ]
#then
#echo entre al 3
#		echo "Verifique el numero de B"
#		echo "----------EXIT----------"
#fi

if [ "$cont_b_only" != "" ] && [ "$edo" == "" ] && [ $(awk -v b=$5 'BEGIN{print length(b)}') != 10 ]
then
echo entre al 4
		echo "Verifique el numero de B"
		echo "----------EXIT----------"
fi

if [ "$cont_pais" != "" ] 
then
#echo int 1
		opcion="Internacional"
		op="NORMAL"

fi

if [ "$cont_pais" != "" ] && [ "$5" != "-" ]
then
#echo int2
		opcion="Internacional"
		op="NORMAL"

fi

if [ "$cont_pais" != "" ] && [ "$5" != "-" ] && [ "$cont_internacional" != "00" ]
then
echo "Verifique el numero de B"
echo "----------EXIT----------"
		exit
fi

if [ "$cont_b_in_edo" != "" ]
then
opcion="Nacional"
fi

if [ "$cont_internacional"  != "" ]
then 
opcion="Internacional"
op="NORMAL"
fi

#if [ "$cont_b_in_edo" == "" ] && [ "$cont_internacional" != "00" ]  && [ $cont_edo == 0 ] && [ "$cont_b_only" == "" ]
#then
#echo "Verifique el Numero de B/Destino"
#echo "--------------EXIT--------------"
#exit
#fi

if [ "$6" != "-" ] && [ "$cont_pais" == "" ] && [ $cont_edo == 0 ]
then

echo "Verifique el destino"
echo "----------EXIT----------"
		exit
fi

if [ "${11}" == "CORTA" ]
then 
opcion="Nacional"
op="CORTA"
fi


#####verificar esta parte
################################


################################

################################
################################
################################

################################

################################

################################################################

################################
################################
################################

################################

################################

################################################################

################################
################################
################################

################################

################################

################################################################

################################
################################
################################

################################

################################

################################

################################
################################
################################

################################

################################

################################
#if [ "${11}" == "VIDEOLLAMADA" ]
#then 
#opcion="Nacional"
#op="NORMAL"
#fi

#echo "Selccione el DESTINO: "
#menu="Nacional Internacional"
#select opcion in $menu;
#do

	case $opcion in
		Nacional)
		bandera_nacional=1
		echo -e "\n---Destino Nacional---\nSelecciona el tipo de Marcacion:\n"
		eleccion="Normal Corta PorCobrar"

		
#		select op in $eleccion;
#		do

op=$(echo ${11}|tr -d ' '|tr '[a-z]' '[A-Z]')
echo -e "\n---"$op"---"

			case $op in
				Normal|normal|NORMAL|VIDEOLLAMADA|videollamada|Videollamada) #mod 10/6/2020
					echo $op
					var8_sms="0"
					var42_sms="2"
					var43_sms="2"
					bandera_marcacion_corta=0
					bandera_marcacion_porcobrar=0
					
					if [ "$5" == "-" ]
					then
					respuesta="Y"
					else 
					respuesta="N"
					fi

					#read -p "Desea generar de forma aleatoria el numero de \"B\" (Y/N)? " respuesta
					#respuesta="Y"
					while [[ ! $respuesta =~ ^[yYnN]$ ]]
					do
						#clear
						read -p "Desea generar de forma aleatoria el numero de \"B\" (Y/N)? " respuesta
					done
						
					if [[ $respuesta =~ ^[yY]$ ]]
						then
						
						
						
							#MOD PARA IMPLEMENTAR TODOS LOS HEADER POSIBLES DEL ARCHIVO NUM_ANALYSIS 23/4/2020
							#SE CALCULA UN NUMERO RANDOM ENTRE 2 y el numero total de lineas que tiene al archivo headers 23/4/2020

							header_random=$(shuf -n 1 -i 2-`awk 'END{print NR}' ./datos/headers.txt`)
							#header_random=32112
							
							#header_random=$(echo $((2+$RANDOM%$(awk 'END{p rint NR}' ./datos/headers.txt))))
							#se obtiene el header 23/4/2020
							header=$(sed -n "$header_random"p ./datos/headers.txt |awk -F'@' '{print ($1)}')
							#se obtiene el numero de digitos faltantes para completar los 10 del numero de B 24/3/2020
							longitud_header=$(expr 10 - $(sed -n "$header_random"p ./datos/headers.txt |awk -F'@' '{print length($1)}'))
							numero_de_B="0052"$header$(for i in `seq 1 $longitud_header` ;do echo -n $(($RANDOM%10));done);
							#se agrego el prefijo 0052 a los numeros generados para que se vieran reflejados den el cdrs 5/5/2020
							#$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))
							#numero_de_B="005255"$(echo -n $((1+$RANDOM%9)))$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))
					
					
						if [ "$5" == "-" ] && [ "$cont_edo" != "" ]
						then
						
						header=$(grep -Ei "@$edo@" ./datos/new_headers.txt|sed -n $(shuf -n 1 -i 1-$(grep -Ei "@$edo@" ./datos/new_headers.txt|wc -l))"p"|awk -F'@' '{print $1}')
						longitud_header=$(expr 10 - $(echo $header|awk '{print length($1)}'))

						numero_de_B="0052"$header$(for i in `seq 1 $longitud_header` ;do echo -n $(($RANDOM%10));done);

						fi

					
					fi
					
					if [[ $respuesta =~ ^[nN]$ ]]
						then
							#read -p "Ingrese el numero de \"B\": " num_B
							num_B=$5
							while [[ ! $num_B =~ ^[0-9]{10,10}$ ]]
								do
									#clear
									read -p "Ingrese el numero de \"B\": " num_B
								done
								numero_de_B="0052"$num_B
					fi
					
##Aqui iba lo de llamada por cobrar			
			;;
		
				Corta|CORTA|corta)
					echo $op
					var8_sms="0"
					var42_sms="0"
					var43_sms="1" #mod 25/3/2020 se realiza el cambio al valor 1 para que el numero marcado salga como nacional en la factura
					bandera_marcacion_corta=1
					bandera_marcacion_porcobrar=0
					#read -p "Ingresa el numero corto: " num_B
					#echo $num_B|cat -A|grep -E '^\**[[:digit:]]{1,8}\$' >/dev/null 2>&1
					#val_num_B=$(echo $?)
					#while [ $val_num_B != 0 ] || [[ ! $(echo ${#num_B}) =~ ^[1-8]+$ ]]
					#	do
					#		echo "Numero incorrecto"
					#		read -p "Ingresa el numero corto: " num_B
					#		echo $num_B|cat -A|grep -E '^\**[[:digit:]]{1,8}\$' >/dev/null 2>&1
					#		val_num_B=$(echo $?)
					#	done
					#	numero_de_B="0052"$num_B
					num_B=$5
					numero_de_B="0052"$num_B

			
			;;
			
					PorCobrar|porcobrar|PORCOBRAR)
					echo $op
					bandera_marcacion_porcobrar=1
					bandera_marcacion_corta=0 #mod 25/3/2020 se establece en cero para que en el campo 44 no asigne un 2
					#numero_de_B="B033554369"$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))
					var8_sms="0"
					var42_sms="1"
					var43_sms="1"
					
					
					if [ "$5" == "-" ]
						then
							header_random=$(shuf -n 1 -i 2-`awk 'END{print NR}' ./datos/headers.txt`)
							header=$(sed -n "$header_random"p ./datos/headers.txt |awk -F'@' '{print ($1)}')
							#se obtiene el numero de digitos faltantes para completar los 10 del numero de B 9/6/2020
							longitud_header=$(expr 10 - $(sed -n "$header_random"p ./datos/headers.txt |awk -F'@' '{print length($1)}'))
							numero_de_B="B033"$header$(for i in `seq 1 $longitud_header` ;do echo -n $(($RANDOM%10));done);
							#se agrego el prefijo B033 a los numeros generados para que se vieran reflejados en el cdrs 9/6/2020
					
					
							if [ "$5" == "-" ] && [ "$cont_edo" != "" ]
								then
							
									header=$(grep -Ei "@$edo@" ./datos/new_headers.txt|sed -n $(shuf -n 1 -i 1-$(grep -Ei "@$edo@" ./datos/new_headers.txt|wc -l))"p"|awk -F'@' '{print $1}')
									longitud_header=$(expr 10 - $(echo $header|awk '{print length($1)}'))
									numero_de_B="B033"$header$(for i in `seq 1 $longitud_header` ;do echo -n $(($RANDOM%10));done);
							fi
					fi
					
					if [ "$5" != "-" ]
						then
							num_B=$5
							while [[ ! $num_B =~ ^[0-9]{10,10}$ ]]
								do
									echo "Numero incorrecto"
									read -p "Ingrese el numero de \"B\": " num_B
								done
							numero_de_B="B033"$num_B
					fi

				;;
				
			
					*)
					echo "Opcion incorrecta"
					echo "Revise el campo 11"
					#echo "-------EXIT------"
					#exit 0
			
			;;
			esac

;;

		Internacional)
		var8_sms="0"
		var42_sms="2"
		var43_sms="2"
		bandera_nacional=0
		bandera_marcacion_porcobrar=0
		bandera_marcacion_corta=0 #mod 25/3/2020 se establece en cero para que en el campo 44 no asigne un 2
		echo -e "\n---Destino Internacional---"
		#read -p "Ingrese el grupo destino: " destino
		destino=$6
        while [ $(validaDestino $destino) != 0 ]
        do
        echo "Grupo incorrecto"
        read -p "Ingrese el grupo destino: " destino
        done
        #echo -e "\n-----------------------------\n"
		
		if [ "$5" == "-" ]
		then
		numero_de_B=$(grep -E "^$destino\_" ./datos/origen_nacional_destino_internacional.txt | awk -F'_' '{print $2}')
		#mod24-7-2020
		num_B=$numero_de_B
		else 
		numero_de_B=$5
		num_B=$numero_de_B

		fi
		#numero_de_B=$(grep -E "^$destino" ./datos/origen_nacional_destino_internacional.txt | awk -F'_' '{print $2}')
		#num_B=$numero_de_B
		#break
		;;
		*)
		echo "Opcion incorrecta"
		echo "-------EXIT------"
		exit 0
		;;
	esac
#done

#opcion=""
###############################################################################
#---------------OBTENGO EL NUMERO DE CASOS DE TRAFICO A GENERAR---------------#
###############################################################################
#read -p "Cuantos casos de trafico quiere generar (Max 100mil)? " num_cdrs
num_cdrs=$2 #mod 20-3-2020 se asigna el valor del segundo parametro que se le pase al script
#
echo $num_cdrs|cat -A | grep -E '^[[:digit:]]{1,6}\$' >/dev/null 2>&1
val_nums_cdr=$(echo $?)

while [ $val_nums_cdr != 0 ] || [ $num_cdrs -gt 100000 ] || [ $num_cdrs -lt 1 ]
do
read -p "Valor no admitido, ingrese otro (Max 100mil): " num_cdrs
echo $num_cdrs|cat -A | grep -E '^[[:digit:]]{1,6}\$' >/dev/null 2>&1
val_nums_cdr=$(echo $?)
echo "$num_cdrs"
done

###############################################################################
#-------------------------OBTENGO LA PRIMERA FECHA----------------------------#
###############################################################################
#echo -e "\e[1;47;41m****Si ingresa la misma fecha y hora podrá generar CDRs en un rango de tiempo dado****\e[0m"
#echo -e "\nFecha de Inicio"
#read -ep "Ingresa la fecha con el sig. formato (DD/MM/YYYY) :  " fecha_inicio
fecha_inicio=$1
while [ $(validaFecha $fecha_inicio) != 0 ]
do
echo "Fecha no valida"
read -ep "Ingresa la fecha (DD/MM/YYYY) :  " fecha_inicio
done

#read -ep "Ingresa la hora inicial \"24hrs\" (hh:mm:ss): " tiempo_inicial

while [ $(validaTiempo $8) != 0 ]
do
echo "Hora no valida"
read -ep "Ingresa la hora inicial (hh:mm:ss) :  " tiempo_inicial
done

if [ "$8" == "-" ]
then
tiempo_inicial=$(echo $(shuf -n 1 -i 0-23)":"$(shuf -n 1 -i 0-59)":"$(shuf -n 1 -i 0-59))
fi

if [ $(validaTiempo $8) == 0 ]
then
tiempo_inicial=$8
fi


###################################################################################################
#-------Obtengo los segundos transcurridos para poder calcular el rango de cdrs por segundo-------#
#                                                                                                 #
sum_fecha1=`date -d "$(formatoFecha $fecha_inicio) $tiempo_inicial" +%s`						  #
#echo -e "\n   $(formatoFecha $fecha_inicio) $tiempo_inicial"									  #
###################################################################################################

#echo "-----------------------------"
#
###############################################################################
#-------------------------OBTENGO LA SEGUNDA FECHA----------------------------#
###############################################################################
#echo -e "Fecha de Fin"
#read -ep "Ingresa la fecha con el sig. formato (DD/MM/YYYY) :  " fecha_fin
fecha_fin=$fecha_inicio
while [ $(validaFecha $fecha_fin) != 0 ]
do
echo "Fecha no valida"
read -ep "Ingresa la fecha (DD/MM/YYYY) :  " fecha_fin
done

#read -ep "Ingresa la hora final \"24hrs\" (hh:mm:ss): " tiempo_final

while [ $(validaTiempo $9) != 0 ]
do
echo "Hora no valida"
read -ep "Ingresa la hora final(hh:mm:ss) :  " tiempo_final
done

if [ $(validaTiempo $9) == 0 ]
then
tiempo_final=$9
fi

if [ "$9" == "-" ]
then
#tiempo_final=$(echo $(shuf -n 1 -i 0-23)":"$(shuf -n 1 -i 0-59)":"$(shuf -n 1 -i 0-59))
tiempo_final=`date -d "$(formatoFecha $fecha_inicio) +$(shuf -n 1 -i 30-3600)"seconds" $tiempo_inicial"` 
fi

###################################################################################################
#-------Obtengo los segundos transcurridos para poder calcular el rango de cdrs por segundo-------#
#																								  #
sum_fecha2=`date -d "$(formatoFecha $fecha_fin) $tiempo_final" +%s`								  #


#read -p "Desea ingresar un rango de tiempo fijo ?: " pregunta
<<desabilitado
###############################################################################
#------------------Verifico que haya mas segundos que cdrs--------------------#
###############################################################################

while [ $(echo "$(($sum_fecha1-$sum_fecha2))"| tr -d '\-') -lt $num_cdrs ] && [ "$pregunta" != "Y" ]
do
echo -e "Error, hay muy pocos segundos para cada cdr"
read -ep "Ingresa una Fecha Fin mayor (DD/MM/YYYY) :  " fecha_fin

while [ $(validaFecha $fecha_fin) != 0 ]
do
echo "Fecha no valida"
read -ep "Ingresa la Fecha Fin (DD/MM/YYYY) :  " fecha_fin
done

read -ep "Ingresa la hora final \"24hrs\" (hh:mm:ss): " tiempo_final

while [ $(validaTiempo $tiempo_final) != 0 ]
do
echo "Hora no valida"
read -ep "Ingresa la hora fin (hh:mm:ss) :  " tiempo_final
done

sum_fecha2=`date -d "$(formatoFecha $fecha_fin) $tiempo_final" +%s`
done
desabilitado

#############################################################################
#----Si la hora inicio es mayor que la hora fin sumo un dia a la fecha-----#
#############################################################################
if [ $sum_fecha2 -lt $sum_fecha1 ]
then
#clear
echo -e "\n          \e[1;47;41m#Advertencia\e[0m"
echo -e "\nSe va a sumar un día mas a la fecha\n"
echo "  -Fecha inicio:  $fecha_inicio $tiempo_inicial" 

#tmp_fecha=$fecha_inicio
#fecha_inicio=$fecha_fin
fecha_fin=`date -d "$(formatoFecha $fecha_fin) +1day" +%d/%m/%Y`
sum_fecha2=`date -d "$(formatoFecha $fecha_fin) $tiempo_final" +%s`

#tmp_tiempo=$tiempo_inicial
#tiempo_inicial=$tiempo_final
#tiempo_final=$tmp_tiempo

#echo -e "\033[7m Presione ENTER para continuar \033[0m"
#read cualquiera
#clear
echo -e "  -Fecha fin:     $fecha_fin $tiempo_final\n"

fi


<<comentario1
#############################################################################
#----INTERCAMBIO LAS FECHAS SI LA SEGUNDA FECHA ES MENOR QUE LA PRIMERA-----#
#############################################################################
if [ $sum_fecha2 -lt $sum_fecha1 ]
then
tmp_fecha=$fecha_inicio
fecha_inicio=$fecha_fin
fecha_fin=$tmp_fecha

tmp_tiempo=$tiempo_inicial
tiempo_inicial=$tiempo_final
tiempo_final=$tmp_tiempo
fi
comentario1
#############################################################################
#----------OBTENGO EL RANGO EN SEGUNDOS EN QUE SE GENERARA CADA CDR---------#
#############################################################################
cdr_xseg=$(($(echo "$(($sum_fecha1-$sum_fecha2))"| tr -d '\-')/$num_cdrs))

#********************************************************************************************************#
#-----SI LA FECHA DE INICIO ES LA MISMA QUE LA FECHA FIN PIDO UN RANGO DE HORAS PARA GENERAR LOS CDR-----#
#********************************************************************************************************#
if [ $sum_fecha1 == $sum_fecha2 ]
then
echo -e "\033[7m Ingreso la misma fecha \033[0m"
echo -e "\033[7m Presione ENTER para continuar \033[0m"
read cualquiera
#clear
echo -e "\n\n---GENERAR CDR EN UN RANGO DE TIEMPO DADO---"
echo -e "\n          Fecha: $(formatoFecha $fecha_inicio)\n\n"
read -p "Tiempo inicial a partir del cual se generara el primer caso de trafico (hh:mm:ss): " tiempo_inicial
while [ $(validaTiempo $tiempo_inicial) != 0 ]
do
echo "Hora inicial invalida"
read -ep "Ingresa la hora inicial (hh:mm:ss) :  " tiempo_inicial
done
##############################################################################
#------AQUI PIDO EL RANGO DE TIEMPO CON EL QUE SE VA A GENERAR CADA CDR------#
##############################################################################
#####################
#----OBTENGO HORA---#
#####################
read -p "Rango en horas: " hora #max 744 horas que son las que hay en 31 dias
echo $hora|cat -A | grep -E '^[[:digit:]]{1,3}\$' >/dev/null 2>&1
val_hora=$(echo $?)
while [ $val_hora != 0 ]
do
echo "Hora incorrecta"
read -p "Ingrese rango en horas: " hora
echo $hora|cat -A | grep -E '^[[:digit:]]{1,3}\$' >/dev/null 2>&1
val_hora=$(echo $?)
done
#####################
#--OBTENGO MINUTOS--#
#####################
read -p "Rango en minutos: " minuto #max 44640 minutos que son los que hay en 31 dias
echo $minuto|cat -A | grep -E '^[[:digit:]]{1,5}\$' >/dev/null 2>&1
val_minuto=$(echo $?)
while [ $val_minuto != 0 ]
do
echo "Minutos incorrectos"
read -p "Ingrese rango en minutos: " minuto
echo $minuto|cat -A | grep -E '^[[:digit:]]{1,5}\$' >/dev/null 2>&1
val_minuto=$(echo $?)
done
######################
#--OBTENGO SEGUNDOS--#
######################
read -p "Rango en segundos: " segundo #max 2678400 segundos que son los que hay en 31 dias
echo $segundo|cat -A | grep -E '^[[:digit:]]{1,7}\$' >/dev/null 2>&1
val_segundo=$(echo $?)
while [ $val_segundo != 0 ]
do
echo "Segundos incorrectos"
read -p "Ingrese rango en segundos: " segundo
echo $segundo|cat -A | grep -E '^[[:digit:]]{1,7}\$' >/dev/null 2>&1
val_segundo=$(echo $?)
done
#################################################
#-----DETERMINO LOS SEGUNDOS ENTRE CADA CDR-----#
#################################################
cdr_xseg=$(($(echo "$hora*3600"| bc)+$(echo "$minuto*60"|bc)+$(echo "$segundo*1"|bc)))

echo -e "\nSe generaran los cdr a partir de la Fecha: $(formatoFecha $fecha_inicio) con el tiempo $tiempo_inicial\n"
fi

##################################
#---AQUI PIDO EL NUMERO DE "A"---#
##################################
####CAMPO 4####

#read -p "Ingrese el numero de \"A\" (10 digitos): " num_tel
num_tel=$3
echo $num_tel|cat -A | grep -E '^[[:digit:]]{10,10}\$' >/dev/null 2>&1
val_num_tel=$(echo $?)
while [ $val_num_tel != 0 ]
do
echo "Numero incorrecto"
read -p "Ingrese numero con 10 digitos: " num_tel
echo $num_tel|cat -A | grep -E '^[[:digit:]]{10,10}\$' >/dev/null 2>&1
val_num_tel=$(echo $?)
done
#echo "-----------------------------"
#
if [ $bandera_marcacion_porcobrar -eq 1 ] #06/mar/20 mod llamada por cobrar template ivan
then
numero_de_A=$num_tel
else
numero_de_A="0052"$num_tel""
fi

###############################################################################
#------------------------DETERMINO EL ID DE LA MATRIZ-------------------------#
###############################################################################
#read -p "Ingrese el ID de inicio (Ejemplo -OCG1-): " matriz
#echo
matriz="OCZ"$(expr $(grep OCZ ./datos/id_matrices_gprs.txt |awk -F'_' '{print $2}') + 1)
id_inicio=$(expr $(echo $matriz|grep -Eo "[0-9]+$") / 1)
matriz=$(echo $matriz|grep -Eo "^[[:alpha:]]+")
id_max=$(grep -E '^'$matriz'_' ./datos/id_matrices_gprs.txt | awk -F'_' '{print $2}')

#Estas variables las utlizo para mostrar los errores, contienen el valor original y se actualizan solamente si se modifica el id
id_inicio1=$id_inicio
matriz1=$matriz
id_max1=$id_max

while [ $(validaMatriz $matriz) != 0 ] || [[ ! $id_inicio =~ ^[0-9]+$ ]] || [ $id_inicio -le $id_max ]
do
if [ $(validaMatriz $matriz) == 0 ] && [[  $id_inicio =~ ^[0-9]+$ ]] && [ $id_inicio -le $id_max ] #Determino el error a mostrar
then
#
if [ "$matriz1" != "$matriz" ]
then
matriz1=$matriz
fi
if [ "$id_max1" != "$id_max" ]
then
id_max1=$id_max
fi
error="Ingrese un ID mayor a -$matriz1$id_max1-: "
fi
if [ $(validaMatriz $matriz) != 0 ] || [[ ! $id_inicio =~ ^[0-9]+$ ]]
then
error="Error ID incorrecto: "
fi
read -p "$error" matriz
id_inicio=$(echo $matriz|grep -Eo "[0-9]+$")
matriz=$(echo $matriz|grep -Eo "^[[:alpha:]]+")
id_max=$(grep -E '^'$matriz'_' ./datos/id_matrices_gprs.txt | awk -F'_' '{print $2}')
done
id_final=""$matriz"_"$( expr $(expr $id_inicio + $num_cdrs) - 1)""
#--Obtengo la longitud del numero del id--
#longitud_id=$(echo ${#id_inicio})
#echo "-----------------------------"
#

<<comentario2
###############################################################################
#------------------------DETERMINO EL ID DE LA MATRIZ-------------------------#
###############################################################################
read -p "Ingrese el ID de la Matriz (Ejemplo \"OCJ\"): " matriz
while [ $(validaMatriz $matriz) != 0 ]
do
echo "Error ID incorrecto"
read -p "Ingrese el ID de la Matriz (Ejemplo \"OCJ\"): " matriz
done
echo "-----------------------------"
#
comentario2

###############################################################################
#----------------------DEFINO CONSUMO ENTRANTE O SALIENTE---------------------#
###############################################################################
#echo "Seleccione el tipo de Consumo: "
menu="Entrante Saliente"

#select opcion in $menu;
#do

direccion=$7

#if [ "$op" == "PORCOBRAR" ]
#then
#direccion="ENTRANTE"
#fi

if [ "$op" == "PORCOBRAR" ] && [ "$7" == "PATROCINADA" ]
then
direccion="SALIENTE"
fi

	case $direccion in
		Entrante|ENTRANTE|entrante)
		bandera_consumo_ent_sal=1
		echo -e "\n---Cosumo Entrante---"
		var11_sms=1
		var3_sms=$numero_de_B
		var4_sms=$numero_de_A
		var9_sms=$numero_de_A
		var10_sms=$numero_de_A
		var13_sms=""
		var15_sms="5294100000980"
		var17_sms=$numero_de_A
		if [ $bandera_marcacion_porcobrar -eq 1 ] #06/mar/20 mod llamada por cobrar template ivan
		then
		var13_sms="5294100000980"
		var17_sms=""
		fi
		
#		break
		;;
		Saliente|SALIENTE|saliente)
		bandera_consumo_ent_sal=0
		echo -e "\n---Cosumo Saliente---"
		var11_sms=0
		var3_sms=$numero_de_A
		var4_sms=$numero_de_B
		var9_sms=$numero_de_B
		var10_sms=$numero_de_B
		var13_sms="5294100000980"
		var15_sms=""
		var17_sms=$numero_de_B
		if [ $bandera_marcacion_porcobrar -eq 1 ] #06/mar/20 mod llamada por cobrar template ivan
		then
		var13_sms="5294100000980"
		var17_sms=""
		fi
		
#		break
		;;
		*)
		echo "Opcion incorrecta"
		echo "Revise el campo 7"
		#echo "-------EXIT------"
		#exit 0
		;;
	esac
#done

###--DEFINO EL TIPO DE CDR, SI ES LLAMADA O SI ES VIDEOLLAMADA--##
#clear
#read -p "Desea cambiar el tipo de CDR? Default: -->llamada<-- (Y/N)? " respuesta
respuesta="N"

if [ "${11}" == "VIDEOLLAMADA" ]
then
respuesta="Y"
opt=${11}
fi

					while [[ ! $respuesta =~ ^[yYnN]$ ]]
					do
					#clear
					read -p "Desea cambiar el tipo de CDR? Default: -->llamada<-- (Y/N)? " respuesta
					done

if [[ $respuesta =~ ^[yY]$ ]]
then
#clear
		#echo -e "\nSelecciona el tipo de CDR:\n"
		#eleccion="Video-call Voice-Data Fax"
		
		#select op in $eleccion;
		#do
			case $opt in
				VIDEOLLAMADA)
				var19_sms="8"
			#break
			;;
				VOICEDATA)
				var19_sms="9"
			#break
			;;
				FAX)
				var19_sms="10"
			#break
			;;
				*)
					echo "Opcion incorrecta"
			;;
			esac
		#done
fi
if [[ $respuesta =~ ^[nN]$ ]]
then
var19_sms="0"				
fi

#####################
#-----BANDERAS------#
#####################
bandera_imsi=0
bandera_cell_id=1
inicio=`cat ./datos/ultimo_numero_voz_nacional.txt`
fin=0 #esta variable es para llevar el control de los IDs del campo 37
<<main
       M             M            A              II     N          N
       MM           MM           A A             II     NN         N
       M  M       M  M          AA AA            II     N N        N
       M   M     M   M         AA   AA           II     N  N       N
       M    M   M    M        AA     AA          II     N   N      N
       M     M M     M       A A A A A A         II     N    N     N
       M      M      M      AA         AA        II     N     N    N
       M             M     AA           AA       II     N      N   N
       M             M    AA             AA      II     N       N  N
       M             M   AA               AA     II     N        N N
       M             M  AA                 AA    II     N         NN
main

#####################-------MAIN--------#######################
#                                                 #
#-----------------CONTADOR GLOBAL-----------------#
#                                                 #
###################################################
for ((contador_global=1; contador_global<=$num_cdrs; contador_global++))
do

if [ $contador_global == $num_cdrs ]
then
segundos_totales=`echo "$sum_fecha1-$sum_fecha2"|bc|tr -d '\-'`
resto_segundos=`echo "$segundos_totales%$num_cdrs"|bc`
cdr_xseg=`echo "$cdr_xseg+$resto_segundos"|bc`

fi

####CAMPO 1####--Service key--
var1_sms="91"

####CAMPO 2####
var2_sms="0"
if [ $bandera_marcacion_porcobrar -eq 1 ] #06/mar/20 mod llamada por cobrar template ivan
then
var2_sms=""
fi

####CAMPO 3####
var3_sms=$var3_sms

####CAMPO 4####
var4_sms=$var4_sms

####CAMPO 5####
var5_sms=""

####CAMPO 6####
var6_sms=""

####CAMPO 7####--Tiempo inicio--
tiempo=`date -d "$(formatoFecha $fecha_inicio) +$(($cdr_xseg*$(($contador_global-1))))"seconds" $tiempo_inicial"` 
time_hhmmss=`echo "$tiempo"|grep -o "..:..:.."| tr -d :`
anio=`echo "$tiempo"|grep -o '[[:digit:]]*$'`
mes=`echo "$tiempo"|grep -o '[[:alpha:]]*'|sed -n 2p`
dia=`echo $tiempo|awk '{printf("%2.2d", $3)}'`
var7_sms="$anio$(mesAnumeros $mes)$dia$time_hhmmss"

####CAMPO 8#### 
var8_sms=$var8_sms

####CAMPO 9####
var9_sms=$var9_sms

####CAMPO 10####
var10_sms=$var10_sms

####CAMPO 11####
var11_sms=$var11_sms

####CAMPO 12####
var12_sms=""

####CAMPO 13####
var13_sms=$var13_sms

####CAMPO 14#### CELL_ID
if [ $bandera_cell_id == 0 ]
then
echo "Desea ingresar el cell_ID?: "
menu="YES NO"
select opcion in $menu;
do
	case $opcion in
		YES)
		bandera_cell_id=0
		break
		;;
		NO)
		bandera_cell_id=1
		break
		;;
		*)
		echo "Opcion incorrecta"
		;;
	esac
done
fi

if [ $bandera_cell_id == 0 ]
then
read -p "Ingrese el cell_ID de origen(15 Digitos): " cell_ID
echo $cell_ID|cat -A | grep -E '^[[:digit:]]{15,20}\$' >/dev/null 2>&1
val_cell_id=$(echo $?)

while [ $val_cell_id != 0 ]
do
echo "valor incorrecto"
read -p "Ingrese el cell_ID de origen(15 Digitos): " cell_ID
echo $cell_ID|cat -A | grep -E '^[[:digit:]]{15,20}\$' >/dev/null 2>&1
val_cell_id=$(echo $?)
done
var14_sms="$cell_ID"
fi
var14_sms="$cell_ID"
#bandera_cell_id=1

####CAMPO 15####
var15_sms=$var15_sms

####CAMPO 16#### CELL_ID_DESTINO

if [ $bandera_cell_id == 0 ]
then
read -p "Ingrese el cell_ID de destino(15 Digitos): " cell_ID_destino
echo $cell_ID_destino|cat -A | grep -E '^[[:digit:]]{15,20}\$' >/dev/null 2>&1
val_cell_id_destino=$(echo $?)

while [ $val_cell_id_destino != 0 ]
do
echo "valor incorrecto"
read -p "Ingrese el cell_ID de destino(15 Digitos): " cell_ID_destino
echo $cell_ID_destino|cat -A | grep -E '^[[:digit:]]{15,20}\$' >/dev/null 2>&1
val_cell_id_destino=$(echo $?)
done
var16_sms="$cell_ID_destino"
fi
var16_sms="$cell_ID_destino"
bandera_cell_id=1

#var16_sms=""

####CAMPO 17####
var17_sms=$var17_sms

####CAMPO 18####
var18_sms=""

####CAMPO 19#### 
var19_sms=$var19_sms
if [ $bandera_marcacion_porcobrar -eq 1 ] #06/mar/20 mod llamada por cobrar template ivan
then
var19_sms=""
fi

####CAMPO 20####
var20_sms=""

####CAMPO 21####
var21_sms=""

####CAMPO 22####
var22_sms=""

####CAMPO 23####
var23_sms="0"

####CAMPO 24####---IMSI---
if [ $bandera_imsi == 0 ]
then
#read -p "Ingrese el IMSI(15 Digitos): " imsi
imsi=$4
echo $imsi|cat -A | grep -E '^[[:digit:]]{15,15}\$' >/dev/null 2>&1
val_imsi=$(echo $?)

while [ $val_imsi != 0 ]
do
echo "IMSI incorrecto"
read -p "Ingrese el IMSI(15 Digitos): " imsi
echo $imsi|cat -A | grep -E '^[[:digit:]]{15,15}\$' >/dev/null 2>&1
val_imsi=$(echo $?)
done
var24_sms="$imsi"
fi
var24_sms="$imsi"
bandera_imsi=1

####CAMPO 25####
var25_sms=""

####CAMPO 26####
var26_sms=""

####CAMPO 27####
var27_sms="" #mod 31-08-2020 se manda vacio para que salga en la factura la hora local y no la del pais visitado

####CAMPO 28####
var28_sms=$var7_sms

####CAMPO 29####
var29_sms=$cdr_xseg

####CAMPO 30####
var30_sms="0"

####CAMPO 31####
var31_sms=$cdr_xseg

####CAMPO 32####
var32_sms="-1"

####CAMPO 33####
var33_sms="0"
if [ $bandera_marcacion_porcobrar -eq 1 ] #06/mar/20 mod llamada por cobrar template ivan
then
var33_sms=""
fi

####CAMPO 34####
var34_sms="0"

####CAMPO 35####--ID MATRIZ---
id_inicio=$(echo "$id_inicio"|awk '{printf("%'$longitud_id'.'$longitud_id'd",$1)}')
var35_sms="$matriz$id_inicio"
id_inicio=$(expr $id_inicio + 1)
#<<comentario3
#var35_sms=$matriz"$(($inicio+$fin))"
#comentario3

if [ "${10}" != "-" ]
then 
var35_sms=${10}
fi
#var35_sms="" #mod 20-3-2020 se deja vacio el id de la matriz
#se vuelve a activar el id matriz mod 25/3/2020

####CAMPO 36####
var36_sms=""

####CAMPO 37####
var37_sms=""

####CAMPO 38####
var38_sms=""

####CAMPO 39####
var39_sms=""

####CAMPO 40####
var40_sms=""

####CAMPO 41####
var41_sms="0"

####CAMPO 42####
var42_sms=$var42_sms
<<var42old
if [ "$(echo $num_B|grep -o "*")" == "*" ] || [ $(echo ${#num_B}) -le 8 ]
then
var42_sms="0"
else
var42_sms="2"
fi
var42old

####CAMPO 43####
var43_sms=$var43_sms
<<var43old
if [ "$(echo $num_B|grep -o "*")" == "*" ] || [ $(echo ${#num_B}) -le 8 ]
then
var43_sms="0"
else
var43_sms="2"
fi
var43old

####CAMPO 44####
var44_sms="0"
if [ $bandera_marcacion_porcobrar -eq 1 ] #06/mar/20 mod llamada por cobrar template ivan
then
var44_sms="1"
fi

if [ $bandera_marcacion_corta -eq 1 ] #25/mar/2020 mod llamada marcacion corta template ivan
then
var44_sms="2"
fi

####CAMPO 45####
var45_sms="2"

####CAMPO 46####
var46_sms="2"

####CAMPO 47####
var47_sms="2"
if [ $bandera_marcacion_porcobrar -eq 1 ] #06/mar/20 mod llamada por cobrar template ivan
then
var47_sms="1"
fi

####CAMPO 48####
var48_sms=""

####CAMPO 49####
var49_sms=""

####CAMPO 50####
var50_sms=""
if [ $bandera_marcacion_porcobrar -eq 1 ] #06/mar/20 mod llamada por cobrar template ivan
then
var50_sms="0"
fi

####CAMPO 51####
var51_sms=""

####CAMPO 52####--Nombre del archivo--
var52_sms="w_abr_VMS_`date +%Y%m%d`_`echo $num_archivos|awk '{printf("%6.6d", $1)}'`.unl"
nombre_archivo=$var52_sms
if [ $bandera_marcacion_porcobrar == 1 ] #06/mar/20 mod llamada por cobrar template ivan
then
nombre_archivo_contenido="Content_SRS_`date +%Y%m%d`_`echo $num_archivos|awk '{printf("%4.4d", $1)}'`.unl"
fi

####CAMPO 53#### --Numero de linea--
if [ "$respuesta_arch" == "y" ] || [ "$respuesta_arch" == "Y" ] || [ "$respuesta_arch" == "S" ] || [ "$respuesta_arch" == "s" ]
then
var53_sms=$(($var53_sms+$numero_linea))
else
var53_sms=$numero_linea
((numero_linea++))
fi

<<comentario4
if [ "$respuesta_arch" == "y" ] || [ "$respuesta_arch" == "Y" ] || [ "$respuesta_arch" == "S" ] || [ "$respuesta_arch" == "s" ] || [ $(cat ./datos/ejecucion_voz_nacional.txt) == 0 ] || [ $valido_archivo != 0 ]
then
var53_sms=$(($var53_sms+1))
fin=$(($fin+1)) #Aqui puse la variable fin para poder usarla con el numero de linea de cada caso de trafico aparte de los IDs del campo 1
else
var53_sms=$(($inicio+$fin))
fin=$(($fin+1))
fi
comentario4

####CAMPO 54####
var54_sms=""

####CAMPO 55####
var55_sms=""

####CAMPO 56####
var56_sms=""
if [ $bandera_marcacion_porcobrar -eq 1 ] #06/mar/20 mod llpc template ivan
then
var56_sms="4"
fi

####CAMPO 57####
var57_sms=""
if [ $bandera_marcacion_porcobrar -eq 1 ] #06/mar/20 mod llpc template ivan
then
var57_sms="1"
fi

####CAMPO 58####
var58_sms=""

####CAMPO 59####
var59_sms=""

####CAMPO 60####
var60_sms=""

####CAMPO 61####
var61_sms=""

####CAMPO 62####
var62_sms=""

####CAMPO 63####
var63_sms=""

####CAMPO 64####
var64_sms=""


echo "$var1_sms|$var2_sms|$var3_sms|$var4_sms|$var5_sms|$var6_sms|$var7_sms|$var8_sms|$var9_sms|$var10_sms|$var11_sms|$var12_sms|$var13_sms|$var14_sms|$var15_sms|$var16_sms|$var17_sms|$var18_sms|$var19_sms|$var20_sms|$var21_sms|$var22_sms|$var23_sms|$var24_sms|$var25_sms|$var26_sms|$var27_sms|$var28_sms|$var29_sms|$var30_sms|$var31_sms|$var32_sms|$var33_sms|$var34_sms|$var35_sms|$var36_sms|$var37_sms|$var38_sms|$var39_sms|$var40_sms|$var41_sms|$var42_sms|$var43_sms|$var44_sms|$var45_sms|$var46_sms|$var47_sms|$var48_sms|$var49_sms|$var50_sms|$var51_sms|$var52_sms|$var53_sms|$var54_sms|$var55_sms|$var56_sms|$var57_sms|$var58_sms|$var59_sms|$var60_sms|$var61_sms|$var62_sms|$var63_sms|$var64_sms|" >> ./CDR/VOZ/NACIONAL/"$nombre_archivo"

if [ $bandera_marcacion_porcobrar == 1 ]
then
echo $(echo $var35_sms|sed 's/OCZ/SCD/g')"|4|"$var7_sms"|0|"$numero_de_A"|0||-2|1103||5||CVMQ@huawei.com|||||||||||||||||"$nombre_archivo_contenido"|"$var53_sms"|" >> ./CDR/VOZ/NACIONAL/"$nombre_archivo_contenido"
fi
#tail -1 ./CDR/VOZ/NACIONAL/"$nombre_archivo"

done

#incremento el contador del numero de lineas para despues actualizar el archivo
if [ "$respuesta_arch" == "y" ] || [ "$respuesta_arch" == "Y" ] || [ "$respuesta_arch" == "S" ] || [ "$respuesta_arch" == "s" ]
then
numero_linea=$(($var53_sms+1))
fi

#--ACTUALIZO EL ARCHIVO PARA EL NUMERO DE ARCHIVOS--#
echo $num_archivos > ./datos/ejecucion_voz_nacional.txt
#--ACTUALIZO EL ARCHIVO PARA LOS NUMEROS DE LINEA--#
echo $numero_linea > ./datos/ultimo_numero_voz_nacional.txt

<<comentario5
-------------------
#--ACTUALIZO EL CONTADOR PARA LOS ID--#
echo $(($inicio+$num_cdrs)) > ./datos/ultimo_numero_voz_nacional.txt
#--ACTUALIZO EL CONTADOR PARA EL NUMERO DE ARCHIVOS--#
echo $num_archivos > ./datos/ejecucion_voz_nacional.txt
comentario5

<<comentario6
#echo -en "\e[1;47;41m Desea agregar mas casos de trafico al mismo archivo? (y/n):\e[0m "
#read respuesta
comentario6

respuesta="n"
if [ "$respuesta" == "y" ] || [ "$respuesta" == "Y" ] || [ "$respuesta" == "S" ] || [ "$respuesta" == "s" ]
then
#matriz_tmp=$(sed -e 's/'$matriz'_[0-9]\+/'$id_final'/g' ./datos/id_matrices_gprs.txt)
matriz_tmp=$(sed -e 's/'$matriz'_/'$id_final'_/g' ./datos/id_matrices_gprs.txt)
echo "$matriz_tmp" > ./datos/id_matrices_gprs.txt
#echo $id_final >> ./datos/limite_id_matriz_gprs.txt #actualizo el archivo con el limite de los 
tmp=$(sed '0d' ./voz_nacional_campos.sh | sed '0d' | sed '0d')
bash <(echo "$tmp")
else
#echo $id_final >> ./datos/limite_id_matriz_gprs.txt #actualizo el archivo con el limite de los ID de matriz
matriz_tmp=$(sed -e 's/'$matriz'_/'$id_final'_/g' ./datos/id_matrices_gprs.txt)
echo "$matriz_tmp" > ./datos/id_matrices_gprs.txt
fi


