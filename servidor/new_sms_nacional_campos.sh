#!/bin/bash

############################################################################################################################################
#------------------------------------------------------------------ARCHIVOS----------------------------------------------------------------#
############################################################################################################################################

if [ ! -e datos ]
then
mkdir datos
echo "1" > ./datos/ultimo_numero_sms_nacional.txt
echo -e "OCA_0\nOCB_0\nOCC_0\nOCD_0\nOCE_0\nOCF_0\nOCG_0\nOCH_0\nOCI_0\nOCJ_0\nSCA_0\nSCB_0\nSCC_0\nSCD_0\nSCE_0\nSCF_0\nSCG_0\nSCH_0\nSCI_0\nSCJ_0\nSCK_0\nSCL_0\nSCM_0\nSCN_0\nSCO_0\nSCP_0\nSCQ_0\nSCR_0\nSCS_0\nSCT_0\nSCU_0\nSCV_0\nSCW_0\nSCX_0\nRCA_0\nRCB_0\nRCC_0\nRCD_0\nRCE_0\nRCF_0\nRCG_0\nRCH_0\nRCI_0\nRCJ_0\nRCK_0\nRCL_0\nRCM_0\nRCN_0\nRCO_0\nRCP_0\nRCQ_0\nRCR_0\nRCS_0\nRCT_0\nRCU_0\nRCV_0\nRCW_0\nRCX_0\nRCY_0\nRCZ_0\nRCZA_0\nRCZB_0\nRCZC_0\nRCZD_0\nRCZE_0\nRCZF_0\nFCA_0\nFCB_0\nFCC_0\nFCD_0\nFCE_0\nFCF_0" > ./datos/id_matrices_gprs.txt
echo -e "ALASKA_0019077627000\nALP_005116171000\nAM1_00541148553912\nAM2_00584142391409\nAMM1_005012232302\nAMM2_005072699741\nBHM_0014412971200\nCAM_0050241102002\nCANADA_0016044741020\nCARIBE_0012423029000\nCARIBEAMERICANO_0013407742525\nCENTROAMERICA_002975869000\nCUBA_005358090577\nDEU_00493021270\nEP1_0033951333484\nEP2_00421484199777\nESP_0034615878068\nEUP_0041414190909\nEUROPA_0037797979696\nHAWAII_0018089435800\nISR_0097237536655\nMU1_0078005000774\nMUNDIAL_0093799654000\nPRI_0017879992010\nRDM_0018094121010\nSATELITAL1_0087032901234\nSATELITAL2_0087434901234\nSATELITAL3_0088167098765\nSATELITAL4_0087057098765\nSATELITAL5_0087078908765\nUSA_0012012081010\nINT_0016703223311" > ./datos/origen_nacional_destino_internacional.txt
echo "0" > ./datos/ejecucion_sms_nacional.txt
fi

if [ ! -f ./datos/ultimo_numero_sms_nacional.txt ]
then
echo "1" > ./datos/ultimo_numero_sms_nacional.txt
fi

if [ ! -f ./datos/id_matrices_gprs.txt ]
then
echo -e "OCA_0\nOCB_0\nOCC_0\nOCD_0\nOCE_0\nOCF_0\nOCG_0\nOCH_0\nOCI_0\nOCJ_0\nSCA_0\nSCB_0\nSCC_0\nSCD_0\nSCE_0\nSCF_0\nSCG_0\nSCH_0\nSCI_0\nSCJ_0\nSCK_0\nSCL_0\nSCM_0\nSCN_0\nSCO_0\nSCP_0\nSCQ_0\nSCR_0\nSCS_0\nSCT_0\nSCU_0\nSCV_0\nSCW_0\nSCX_0\nRCA_0\nRCB_0\nRCC_0\nRCD_0\nRCE_0\nRCF_0\nRCG_0\nRCH_0\nRCI_0\nRCJ_0\nRCK_0\nRCL_0\nRCM_0\nRCN_0\nRCO_0\nRCP_0\nRCQ_0\nRCR_0\nRCS_0\nRCT_0\nRCU_0\nRCV_0\nRCW_0\nRCX_0\nRCY_0\nRCZ_0\nRCZA_0\nRCZB_0\nRCZC_0\nRCZD_0\nRCZE_0\nRCZF_0\nFCA_0\nFCB_0\nFCC_0\nFCD_0\nFCE_0\nFCF_0\nOCFA_0" > ./datos/id_matrices_gprs.txt
fi

if [ ! -f ./datos/origen_nacional_destino_internacional.txt ]
then
echo -e "ALASKA_0019077627000\nALP_005116171000\nAM1_00541148553912\nAM2_00584142391409\nAMM1_005012232302\nAMM2_005072699741\nBHM_0014412971200\nCAM_0050241102002\nCANADA_0016044741020\nCARIBE_0012423029000\nCARIBEAMERICANO_0013407742525\nCENTROAMERICA_002975869000\nCUBA_005358090577\nDEU_00493021270\nEP1_0033951333484\nEP2_00421484199777\nESP_0034615878068\nEUP_0041414190909\nEUROPA_0037797979696\nHAWAII_0018089435800\nISR_0097237536655\nMU1_0061362567888\nMUNDIAL_0093799654000\nPRI_0017879992010\nRDM_0018094121010\nSATELITAL1_0087032901234\nSATELITAL2_0087434901234\nSATELITAL3_0088167098765\nSATELITAL4_0087057098765\nSATELITAL5_0087078908765\nUSA_0012012081010\nINT_0016703223311" > ./datos/origen_nacional_destino_internacional.txt
fi

if [ ! -f ./datos/ejecucion_sms_nacional.txt ]
then
echo "0" > ./datos/ejecucion_sms_nacional.txt
fi

if [ ! -e CDR/SMS/NACIONAL ];then mkdir -p ./CDR/SMS/NACIONAL;fi

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

validaDestino () #Valida el grupo de destino internacional
{
awk -F'_' '{print $1}' ./datos/origen_nacional_destino_internacional.txt|grep -E '^'$1'$' >/dev/null
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

echo -e "\n\n#--ESTE SCRIPT GENERA CASOS DE TRAFICO PARA EL CDR DE SMS NACIONAL--#\n"

<<comentario #no borrar este comentario ya que es para desabilitar la pregunta en la proxima ejecucion
respuesta_arch="n"
comentario

#read -p "Desea generar un nuevo archivo de salida?(y/n): " respuesta_arch
respuesta_arch=${11}

if [ "$respuesta_arch" == "y" ] || [ "$respuesta_arch" == "Y" ] || [ "$respuesta_arch" == "S" ] || [ "$respuesta_arch" == "s" ] || [ $((`cat ./datos/ultimo_numero_sms_nacional.txt`-1)) -eq 100000 ]
then
if [ $((`cat ./datos/ultimo_numero_sms_nacional.txt`-1)) -eq 100000 ] #Verifica que el archivo tenga menos de 100mil registros
then
echo -e "\nAdvertencia\nEl archivo llego al maximo de registros, se generará un nuevo archivo"
fi
num_archivos=$(($(cat ./datos/ejecucion_sms_nacional.txt)+1))
numero_linea=1
limite_archivo_anterior=0
else
numero_linea=`cat ./datos/ultimo_numero_sms_nacional.txt`
limite_archivo_anterior=$(($numero_linea-1))
num_archivos=`cat ./datos/ejecucion_sms_nacional.txt`

if [ $(cat ./datos/ejecucion_sms_nacional.txt) == 0 ] # Verifico si es la primera ejecucion del script
then
limite_archivo_anterior=0
num_archivos=1
numero_linea=1
fi

fi
echo "-----------------------------------------------"
echo


#MOD 5-6-2020

edo=$6
echo "estado:--"$edo"--"
                
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
cont_pais=$(grep -Eio ^"$edo"_ ./datos/origen_nacional_destino_internacional.txt)
cont_b_in_edo=$(grep -Ei "@$edo@" ./datos/new_headers.txt|grep -Eo "^$cont_b_only@")
cont_internacional=$(echo $5|grep -Eo '^00')

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

if [ "$cont_b_in_edo" == "" ] && [ "$5" != "-" ] && [ "$cont_b_only" == "" ] && [ "$cont_internacional" != "00" ] && [ "${10}" != "CORTA" ]
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

if [ "$cont_b_only" != "" ] && [ "$edo" == "" ] && [ $(awk -v b=$5 'BEGIN{print length(b)}') != 10 ]
then
echo entre al 4
		echo "Verifique el numero de B"
		echo "----------EXIT----------"
fi

if [ "$cont_pais" != "" ] 
then
echo int 1
		opcion="Internacional"
		op="NORMAL"

fi

if [ "$cont_pais" != "" ] && [ "$5" != "-" ]
then
echo int2
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

if [ "${10}" == "CORTA" ]
then 
opcion="Nacional"
op="CORTA"
fi


if [ "$6" != "-" ] && [ "$cont_pais" == "" ] && [ $cont_edo == 0 ]
then

echo "Verifique el destino"
echo "----------EXIT----------"
		exit
fi



###############################################################################
#-------------DETERMINO SI EL DESTINO ES NACIONAL O INTERNACIONAL-------------#
###############################################################################
echo "Seleccione el DESTINO: "
#menu="Nacional Internacional"
#select opcion in $menu;
#do

	case $opcion in
		Nacional)
		bandera_nacional=1
		echo -e "\n---Destino Nacional---\nSelecciona el tipo de Marcacion:\n"
		eleccion="Normal Corta PorCobrar"
		
		op=$(echo ${10}|tr -d ' '|tr '[a-z]' '[A-Z]')

		
#		select op in $eleccion;
#		do
			case $op in
			
				Normal|normal|NORMAL)
				echo $op
							bandera_marcacion_porcobrar=0
							var42_sms="2"
							var43_sms="2"
							bandera_marcacion_corta=0
							
							if [ "$5" == "-" ]
							then
							respuesta="Y"
							else 
							respuesta="N"
							fi
							
							
							while [[ ! $respuesta =~ ^[yYnN]$ ]]
							do
								read -p "Desea generar de forma aleatoria el numero de \"B\" (Y/N)? " respuesta
							done
							
								
								if [[ $respuesta =~ ^[yY]$ ]]
									then
										#MOD 5-6-2020
										header_random=$(shuf -n 1 -i 2-`awk 'END{print NR}' ./datos/headers.txt`)
										header=$(sed -n "$header_random"p ./datos/headers.txt |awk -F'@' '{print ($1)}')
										#se obtiene el numero de digitos faltantes para completar los 10 del numero de B 24/3/2020
										longitud_header=$(expr 10 - $(sed -n "$header_random"p ./datos/headers.txt |awk -F'@' '{print length($1)}'))
										var9_sms="0052"$header$(for i in `seq 1 $longitud_header` ;do echo -n $(($RANDOM%10));done);
										#se agrego el prefijo 0052 a los numeros generados para que se vieran reflejados den el cdrs 5/5/2020
													
										if [ "$5" == "-" ] && [ "$cont_edo" != "" ]
										then
										header=$(grep -Ei "@$edo@" ./datos/new_headers.txt|sed -n $(shuf -n 1 -i 1-$(grep -Ei "@$edo@" ./datos/new_headers.txt|wc -l))"p"|awk -F'@' '{print $1}')
										longitud_header=$(expr 10 - $(echo $header|awk '{print length($1)}'))
										var9_sms="0052"$header$(for i in `seq 1 $longitud_header` ;do echo -n $(($RANDOM%10));done);	
										fi
								fi
										
								if [[ $respuesta =~ ^[nN]$ ]]
										then	
										num_B=$5
											while [[ ! $num_B =~ ^[0-9]{10,10}$ ]]
											do
											read -p "Ingrese el numero de \"B\": " num_B
											done
										numero_de_B="0052"$num_B
										var9_sms=$numero_de_B
										
								fi
										
								if [ "${12}" == "RP" ]
									then
									var9_sms="035"$var9_sms
                                fi	
							;;
				
				#FIN MOD 5-6-2020
		
				Corta|CORTA|corta)
					echo $op
					bandera_marcacion_porcobrar=0
					var42_sms="0"
					var43_sms="0"
					
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
					#	var9_sms=$num_B
					
					
					#num_B=$5
					#echo "num B: "$num_B
					#var9_sms
					numero_de_B=$5
					var9_sms=$numero_de_B


			;;
			
				PorCobrar|porcobrar|PORCOBRAR)
					echo $op
					bandera_marcacion_porcobrar=1
					#var42_sms="2"
					var42_sms="2"
					var43_sms="2"
					#var5_sms=$(echo -n $((50+$RANDOM%125)))
					var5_sms=""
					#var6_sms="094100001000"
					var6_sms=""
					#var51_sms="1"
					#var52_sms="1"
					var51_sms=""
					var52_sms=""
					#var9_sms="0052554369"$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))
					#num_B="B033554369"$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))
			;;
		
				*)
					echo "Opcion incorrecta"
			;;
			esac
		#done
		;;
		Internacional)
		bandera_nacional=0
		bandera_marcacion_porcobrar=0
		echo -e "\n---Destino Internacional---"
		#read -p "Ingrese el grupo destino: " destino
		destino=$6
        while [ $(validaDestino $destino) != 0 ]
        do
        echo "Grupo incorrecto"
        read -p "Ingrese el grupo destino: " destino
        done
        echo -e "\n-----------------------------\n"
		#var9_sms=$(grep -E "^$destino" ./datos/origen_nacional_destino_internacional.txt | awk -F'_' '{print $2}')

		if [ "$5" == "-" ]
		then
		num_internacional=$(grep -E "^$destino\_" ./datos/origen_nacional_destino_internacional.txt | awk -F'_' '{print $2}')
		echo "num internacional --> "$num_internacional
		#mod 24-7-2020
		#num_B=$numero_de_B
		else 
		num_internacional=$5
		#num_B=$numero_de_B

		fi


		;;
		*)
		echo "Opcion incorrecta"
		;;
	esac
#done


###############################################################################
#---------------OBTENGO EL NUMERO DE CASOS DE TRAFICO A GENERAR---------------#
###############################################################################
#read -p "Cuantos casos de trafico quiere generar (Max 100mil)? " num_cdrs mod 28/3/2020
echo
num_cdrs=$2
echo $num_cdrs|cat -A | grep -E '^[[:digit:]]{1,6}\$' >/dev/null 2>&1
val_nums_cdr=$(echo $?)

while [ $val_nums_cdr != 0 ] || [ $num_cdrs -gt 100000 ] || [ $num_cdrs -lt 1 ]
do
read -p "Valor no admitido, ingrese otro (Max 100mil): " num_cdrs
echo $num_cdrs|cat -A | grep -E '^[[:digit:]]{1,6}\$' >/dev/null 2>&1
val_nums_cdr=$(echo $?)
echo "$num_cdrs"
done

#echo $vlr
#######################################################################################
#-------------------------OBTENGO EL TIEMPO Y FECHA INICIAL---------------------------#
#######################################################################################
echo -e "\nFecha de Inicio"
#read -ep "Ingresa la fecha con el sig. formato (DD/MM/YYYY) :  " fecha_inicio mod 28/3/2020
fecha_inicio=$1
while [ $(validaFecha $fecha_inicio) != 0 ]
do
echo "Fecha no valida"
read -ep "Ingresa la fecha (DD/MM/YYYY) :  " fecha_inicio
done

#read -ep "Ingresa la hora inicial \"24hrs\" (hh:mm:ss): " tiempo_inicial
tiempo_inicial=$8
while [ $(validaTiempo $tiempo_inicial) != 0 ]
do
echo "Hora no valida"
read -ep "Ingresa la hora (hh:mm:ss) :  " tiempo_inicial
done
cdr_xseg=1
echo -e "\nSe generaran los cdr a partir de la Fecha: $(formatoFecha $fecha_inicio) con el tiempo $tiempo_inicial\n"
echo "----------------------------------------------------------------------------"
echo

##################################
#---AQUI PIDO EL NUMERO DE "A"---#
##################################
####CAMPO 15####
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
echo "-----------------------------"
echo

###############################################################################
#------------------------DETERMINO EL ID DE LA MATRIZ-------------------------#
###############################################################################

#read -p "Ingrese el ID de inicio (Ejemplo -OCG1-): " matriz
echo
matriz="OCH"$(expr $(grep OCH ./datos/id_matrices_gprs.txt |awk -F'_' '{print $2}') + 1)
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
echo
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
echo "-----------------------------"
echo


#MOD 25/3/2020 ENTRANTE O SALIENTE


echo "Seleccione el tipo de Consumo: "
menu="Entrante Saliente"


#select option in $menu;
#do

direccion=$7

if [ "$op" == "PORCOBRAR" ]
then
direccion="Entrante"
fi

	case $direccion in
		Entrante|ENTRANTE|entrante)
		bandera_consumo_ent_sal=1
		echo -e "\n---Cosumo Entrante---"

		#var10_sms=$numero_de_A
		
		#break
		;;
		Saliente|saliente|SALIENTE)
		bandera_consumo_ent_sal=0
		echo -e "\n---Cosumo Saliente---"
		#var10_sms=$numero_de_A

		
		#break
		;;
		*)
		echo "Opcion incorrecta"
		
		;;
	esac
#done

vlr=${13}
#echo ${13}|cat -e
#if [ $(echo ${13}|grep -e "^[0-9]\+\$") ]
#then
#echo "vlr valido"
##var56_sms=$vlr
##echo $var56_sms
#fi

#####################
#-----BANDERAS------#
#####################
bandera_imsi=0
#inicio=`cat ./datos/ultimo_numero_sms_nacional.txt`
#fin=0 #esta variable es para llevar el control de los IDs del campo 37
###################################################
#                                                 #
#-----------------CONTADOR GLOBAL-----------------#
#                                                 #
###################################################
for ((contador_global=1; contador_global<=$num_cdrs; contador_global++))
do
####CAMPO 1####
var1_sms="3"

####CAMPO 2####
var2_sms="1"

####CAMPO 3####
var3_sms=""

####CAMPO 4####
var4_sms=""

####CAMPO 5####
var5_sms="174"

####CAMPO 6####
var6_sms=$var6_sms

####CAMPO 7####
var7_sms=""

####CAMPO 8####---Numero de A---
international_prefix="0052"
var8_sms="$international_prefix$num_tel"

if [ $bandera_marcacion_porcobrar -eq 1 ] && [ "$5" == "-" ] #--si es porcobrar es el num. de B--
then
#var8_sms="B033554369"$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))$(echo -n $(($RANDOM%10)))
	#MOD 9-6-2020
	#header_random=$(shuf -n 1 -i 2-`awk 'END{print NR}' ./datos/headers.txt`)
	#header=$(sed -n "$header_random"p ./datos/headers.txt |awk -F'@' '{print ($1)}')
	header=$(grep -i "TELCEL" ./datos/headers.txt |sort -R|head -1|awk -F'@' '{print ($1)}')
	#se obtiene el numero de digitos faltantes para completar los 10 del numero de B 9/6/2020
	longitud_header=$(expr 10 - $(echo $header|awk '{print length($1)}'))
	var8_sms="B0330052"$header$(for i in `seq 1 $longitud_header` ;do echo -n $(($RANDOM%10));done);
	
	if [ "$5" == "-" ] && [ "$cont_edo" != "" ]
	then
		header=$(grep -Ei "@$edo@" ./datos/new_headers.txt|grep -i "TELCEL"|sort -R|head -1|awk -F'@' '{print ($1)}')
		longitud_header=$(expr 10 - $(echo $header|awk '{print length($1)}'))
		var8_sms="B0330052"$header$(for i in `seq 1 $longitud_header` ;do echo -n $(($RANDOM%10));done);	
	fi
fi

if [ $bandera_marcacion_porcobrar -eq 1 ] && [ "$5" != "-" ] #--si es porcobrar es el num. de B--SI ES ESPECIFICA EL NUMERO SE ASIGNA
then
var8_sms="B033"$5
fi

if [ $7 == "ENTRANTE" ] && [ $5 == "-" ] && [ $bandera_marcacion_porcobrar != 1 ] #MOD 30-12-2020 Se agrego la validacion cuando no es porcobrar no entre aqui y asigne correctamente el prefijo
then

	header_random=$(shuf -n 1 -i 2-`awk 'END{print NR}' ./datos/headers.txt`)
	header=$(sed -n "$header_random"p ./datos/headers.txt |awk -F'@' '{print ($1)}')
	#se obtiene el numero de digitos faltantes para completar los 10 del numero de B 9/6/2020
	longitud_header=$(expr 10 - $(sed -n "$header_random"p ./datos/headers.txt |awk -F'@' '{print length($1)}'))
	var8_sms="$international_prefix"$header$(for i in `seq 1 $longitud_header` ;do echo -n $(($RANDOM%10));done);
	
	if [ "$5" == "-" ] && [ "$cont_edo" != "" ]
	then
		header=$(grep -Ei "@$edo@" ./datos/new_headers.txt|sed -n $(shuf -n 1 -i 1-$(grep -Ei "@$edo@" ./datos/new_headers.txt|wc -l))"p"|awk -F'@' '{print $1}')
		longitud_header=$(expr 10 - $(echo $header|awk '{print length($1)}'))
		var8_sms="$international_prefix"$header$(for i in `seq 1 $longitud_header` ;do echo -n $(($RANDOM%10));done);	
	fi
	
fi

if [ $7 == "ENTRANTE" ] && [ "$5" != "-" ]
then
var8_sms="$international_prefix"$5

fi

if [ $7 == "ENTRANTE" ] && [ "$cont_pais" != "" ]
then
var8_sms=$num_internacional

fi

####CAMPO 9####---Numero de B---
var9_sms=$var9_sms
#echo "num B: "$var9_sms
#read kdk
if [ $7 == "SALIENTE" ] && [ "$cont_pais" != "" ]
then
var9_sms=$num_internacional
fi

if [ $bandera_marcacion_porcobrar -eq 1 ] #--si es porcobrar es el num. de A--
then
var9_sms="$international_prefix$num_tel"
fi


if [ "$7" == "ENTRANTE" ] #si es entrante se pone el numero del cliente en el campo 9 y 10
then
var9_sms="$international_prefix$num_tel"
fi

####CAMPO 10####
var10_sms=$var8_sms
if [ $bandera_marcacion_porcobrar -eq 1 ] || [ $bandera_consumo_ent_sal -eq 1 ]
then
var10_sms=$var9_sms
fi


if [ "$7" == "ENTRANTE" ] #si es entrante se pone el numero del cliente en el campo 9 y 10
then
var10_sms="$international_prefix$num_tel"
fi

####CAMPO 11####
var11_sms="1"
if [ $bandera_marcacion_porcobrar -eq 1 ] && [ "$7" == "ENTRANTE" ]
then
var11_sms="2" #mod 04-enero-2021 >>se cambia el valor a 1 ya que esta generando problemas en el ocs para ver en la factura<<
fi

if [ $bandera_marcacion_porcobrar -eq 1 ] && [ "$7" == "SALIENTE" ]
then
var11_sms="2" #mod 04-enero-2021 >>se cambia el valor a 1 ya que esta generando problemas en el ocs para ver en la factura<<
fi

if [ ! -z "$cont_pais" ] && [ "$7" == "ENTRANTE" ]
then
var11_sms="2" #mod 04-enero-2021 >>se cambia el valor a 1 ya que esta generando problemas en el ocs para ver en la factura<<
fi

if [ $bandera_marcacion_porcobrar -eq 1 ] || [ "$7" == "ENTRANTE" ]
then
var11_sms="2"
fi
####CAMPO 12####
var12_sms="0"

####CAMPO 13####
var13_sms=""

####CAMPO 14####
var14_sms=""

####CAMPO 15####
var15_sms=""

####CAMPO 16####
var16_sms=""

####CAMPO 17####
var17_sms="0"

####CAMPO 18####
var18_sms="0"

####CAMPO 19#### 
tiempo=`date -d "$(formatoFecha $fecha_inicio) +$(($cdr_xseg*$(($contador_global-1))))"seconds" $tiempo_inicial"` 
time_hhmmss=`echo "$tiempo"|grep -o "..:..:.."| tr -d :`
anio=`echo "$tiempo"|grep -o '[[:digit:]]*$'`
mes=`echo "$tiempo"|grep -o '[[:alpha:]]*'|sed -n 2p`
dia=`echo $tiempo|awk '{printf("%2.2d", $3)}'`
var19_sms="$anio$(mesAnumeros $mes)$dia$time_hhmmss"

####CAMPO 20####
var20_sms=""

####CAMPO 21####
var21_sms=""

####CAMPO 22####
var22_sms=""

####CAMPO 23####
var23_sms="0"

####CAMPO 24####
var24_sms=""

####CAMPO 25####
var25_sms=""

####CAMPO 26####
var26_sms=""

####CAMPO 27####
var27_sms=""

####CAMPO 28####
var28_sms=""

####CAMPO 29####
var29_sms=""

####CAMPO 30####
var30_sms=""

####CAMPO 31####
var31_sms=""

####CAMPO 32####
var32_sms=""

####CAMPO 33####
var33_sms=""

####CAMPO 34####
var34_sms=""

####CAMPO 35####
var35_sms=""

####CAMPO 36####
var36_sms=$var8_sms
if [ $bandera_marcacion_porcobrar -eq 1 ]
then
var36_sms=$var9_sms
fi

if [ "$7" == "ENTRANTE" ]
then
var36_sms="$international_prefix$num_tel"
fi


####CAMPO 37#### --ID MATRIZ--
#var37_sms="$matriz"_SMSn"$(($inicio+$fin))"
id_inicio=$(echo "$id_inicio"|awk '{printf("%'$longitud_id'.'$longitud_id'd",$1)}')
var37_sms="$matriz$id_inicio"
id_inicio=$(expr $id_inicio + 1)

if [ "$9" != "-" ]
then
var37_sms=$9
fi

####CAMPO 38####
var38_sms=""

####CAMPO 39####
var39_sms=""

####CAMPO 40####
var40_sms=""

####CAMPO 41####
var41_sms=""

####CAMPO 42####
var42_sms=$var42_sms
if [ $(echo $vlr|grep -e "^[0-9]\+\$") ] && [ $bandera_nacional -eq 0 ]
then
var42_sms="2"
fi

####CAMPO 43####
var43_sms=$var43_sms
if [ $(echo $vlr|grep -e "^[0-9]\+\$") ] && [ $bandera_nacional -eq 0 ]
then
var43_sms="2"
fi


####CAMPO 44####
var44_sms="2"

####CAMPO 45####
var45_sms="2"

####CAMPO 46####
var46_sms=$var9_sms


if [ "${12}" == "RP" ]
	then
	var46_sms=$(echo $var9_sms|sed -e 's/^035//g')
  fi	


if [ $bandera_marcacion_porcobrar -eq 1 ]
then
var46_sms=$var9_sms
fi

if [ "$7" == "ENTRANTE" ]
then
var46_sms=$var36_sms
fi



####CAMPO 47####---Nombre Archivo---
var47_sms="w_smo_SMSCobro_`date +%Y%m%d`_`echo $num_archivos|awk '{printf("%6.6d", $1)}'`.unl"
nombre_archivo=$var47_sms

####CAMPO 48#### ---Numero de linea---
if [ "$respuesta_arch" == "y" ] || [ "$respuesta_arch" == "Y" ] || [ "$respuesta_arch" == "S" ] || [ "$respuesta_arch" == "s" ]
then
var48_sms=$(($var48_sms+$numero_linea))
else
var48_sms=$numero_linea
((numero_linea++))
fi

####CAMPO 49####
var49_sms=""

####CAMPO 50####
var50_sms=""

####CAMPO 51####
var51_sms=$var51_sms

if [ $bandera_marcacion_porcobrar -eq 1 ] || [ "${12}" == "RP" ] || [ $(echo $vlr|grep -e "^[0-9]\+\$") ]
then
var51_sms="1"
fi


####CAMPO 52####
var52_sms=$var52_sms

if [ $bandera_marcacion_porcobrar -eq 1 ] || [ "${12}" == "RP" ] || [ $(echo $vlr|grep -e "^[0-9]\+\$") ]
then
var52_sms="1"
fi


####CAMPO 53####
if [ $bandera_imsi == 0 ]
then
#read -p "Ingrese el IMSI(15 Digitos): " imsi
imsi=$4
echo $imsi|cat -A | grep -E '^[[:digit:]]{15,15}\$' >/dev/null 2>&1
val_imsi=$(echo $?)

while [ $val_imsi != 0 ]
do
echo "valor incorrecto"
read -p "Ingrese el IMSI(15 Digitos): " imsi
echo $imsi|cat -A | grep -E '^[[:digit:]]{15,15}\$' >/dev/null 2>&1
val_imsi=$(echo $?)
done
var53_sms="$imsi"
fi
#var53_sms="$imsi"
bandera_imsi=1

####CAMPO 54####
var54_sms=""

####CAMPO 55####
var55_sms=""

####CAMPO 56####--CAMPO FIJO-- VLR sms saliente 
var56_sms="5294100000980"
#if [ $bandera_marcacion_porcobrar -eq 1 ]
#then
##var56_sms="52941100091100"
#var56_sms=""
#fi

if [ $bandera_marcacion_porcobrar -eq 1 ]
then
echo $bandera_marcacion_porcobrar" bandera porcobrar"
echo "es por cobrar"
var56_sms="5294100000980"
fi

#si el campo 13 es una cadena compuesta de puros numeros signifia que tiene un vlr asignado 6/jun/2022
if [ $(echo $vlr|grep -e "^[0-9]\+\$") ] && [ "$direccion" == "SALIENTE" ]
then
echo $direccion" direccion"
#echo "es saliente y tiene vlr"
var56_sms=$vlr
#echo $var56_sms
fi
if [ $(echo $vlr|grep -e "^[0-9]\+\$") ] && [ "$direccion" == "ENTRANTE" ]
then
#echo "es saliente y tiene vlr"
echo $direccion" direccion"
var56_sms=""
#echo $var56_sms
fi

####CAMPO 57####
var57_sms=""
if [ $bandera_marcacion_porcobrar -eq 1 ]
then
#var57_sms="3340209999999999"
var57_sms=""
fi

####CAMPO 58####
var58_sms=""
if [ $bandera_marcacion_porcobrar -eq 1 ]
then
#var58_sms=$var56_sms
var58_sms="5294100000980"
fi
if [ $(echo $vlr|grep -e "^[0-9]\+\$") ] && [ "$direccion" == "ENTRANTE" ]
then 
var58_sms=$vlr
fi

####CAMPO 59####
var59_sms=""
if [ $bandera_marcacion_porcobrar -eq 1 ]
then
var59_sms=$var57_sms
fi

echo "$var1_sms|$var2_sms|$var3_sms|$var4_sms|$var5_sms|$var6_sms|$var7_sms|$var8_sms|$var9_sms|$var10_sms|$var11_sms|$var12_sms|$var13_sms|$var14_sms|$var15_sms|$var16_sms|$var17_sms|$var18_sms|$var19_sms|$var20_sms|$var21_sms|$var22_sms|$var23_sms|$var24_sms|$var25_sms|$var26_sms|$var27_sms|$var28_sms|$var29_sms|$var30_sms|$var31_sms|$var32_sms|$var33_sms|$var34_sms|$var35_sms|$var36_sms|$var37_sms|$var38_sms|$var39_sms|$var40_sms|$var41_sms|$var42_sms|$var43_sms|$var44_sms|$var45_sms|$var46_sms|$var47_sms|$var48_sms|$var49_sms|$var50_sms|$var51_sms|$var52_sms|$var53_sms|$var54_sms|$var55_sms|$var56_sms|$var57_sms|$var58_sms|$var59_sms|" >> ./CDR/SMS/NACIONAL/"$nombre_archivo"
#tail -1 ./CDR/SMS/NACIONAL/"$nombre_archivo"
done

if [ "$respuesta_arch" == "y" ] || [ "$respuesta_arch" == "Y" ] || [ "$respuesta_arch" == "S" ] || [ "$respuesta_arch" == "s" ]
then
numero_linea=$(($var48_sms+1))
fi

#--ACTUALIZO EL ARCHIVO PARA EL NUMERO DE ARCHIVOS--#
echo $num_archivos > ./datos/ejecucion_sms_nacional.txt
#--ACTUALIZO EL ARCHIVO PARA LOS NUMEROS DE LINEA--#
echo $numero_linea > ./datos/ultimo_numero_sms_nacional.txt


#echo -en "\e[1;47;41m Desea agregar mas casos de trafico al mismo archivo? (y/n):\e[0m "
#read respuesta
respuesta="N"
if [ "$respuesta" == "y" ] || [ "$respuesta" == "Y" ] || [ "$respuesta" == "S" ] || [ "$respuesta" == "s" ]
then
matriz_tmp=$(sed -e 's/'$matriz'_/'$id_final'_/g' ./datos/id_matrices_gprs.txt)
echo "$matriz_tmp" > ./datos/id_matrices_gprs.txt
tmp=$(sed '203d' ./sms_nacional_campos.sh | sed '204d' | sed '205d')
bash <(echo "$tmp")
else
matriz_tmp=$(sed -e 's/'$matriz'_/'$id_final'_/g' ./datos/id_matrices_gprs.txt)
echo "$matriz_tmp" > ./datos/id_matrices_gprs.txt
fi



