#!/bin/bash

## TP Integrador Computacion Aplicada
## Javier Cáceres 2019

USER=$(whoami)
VALPROX=0
VALINI=0
VALNEXT=1

function menu()
{
	echo "TP Integrador Menu:"
	echo "1. Fibonacci"
	echo "2. Valor invertido"
	echo "3. Validar Palindromo"
	echo "4. Contar lineas de un file"
	echo "5. Ordenar Enteros"
	echo "6. Tipos de Archivos por Path"
	echo "7. Salir"
}

menu
read VALMENU

while [ $VALMENU -le 0 ] || [ $VALMENU -ge 8 ];
do
	menu
	read VALMENU
done
if [ $VALMENU -ge 0 ] || [ $VALMENU -le 8 ]; then
	case "$VALMENU"
	in
		1)
			echo "Ingrese valor: "
			read VAL
			#for i in `seq 1 $VAL`;
			echo "Succesion Fibonacci: $VAL Veces"
			for (( i=0 ; i <= $VAL ; i++ ))
			do
				VALPROX=$(($VALINI+$VALNEXT))
				echo $VALPROX
				VALINI=$VALNEXT
				VALNEXT=$VALPROX
			done
			;;
		2)
			echo "Ingrese Valor entero mayor a dos digitos: "
			read VAL
			echo $VAL|rev
			;;
		3)
			echo "Ingrese un string: "
			read VAL
			VALINV=$(echo $VAL|rev)
			if [ $VALINV == $VAL ]; then
				echo "La palabra $VALINV es un Palindromo"
			else
				echo "No es un palindromo"
			fi
			;;
		4)
			echo "Ingrese el Path de un archivo de texto: "
			read RUTA
			if [ -f $RUTA ]; then
				CANT=$(wc -l $RUTA )
				echo "Lineas $CANT"
			else
				echo "El archivo $RUTA No existe"
			fi
		
			;;
		5)	
			VALORES=()
			for(( i=1; i<6 ; i++))
			do
				echo "Ingrese valor $i: "
				read VALORES[$i]
			done
			echo "Valores Ordenados: "
			## Ordenar Valores
			for(( i=1; i<=5 ; i++))
			do
				for ((j=1 ; j<=4 ; j++))
				do
					if [ ${VALORES[$j]} -gt ${VALORES[$j+1]} ]; then
						AUX=${VALORES[$j]}
						VALORES[$j]=${VALORES[$j+1]}
						VALORES[$j+1]=$AUX
					fi
				done
			done
			## Mostrar Valores
			for(( i=1; i <= 5 ; i++))
                        do
			       echo ${VALORES[$i]}
			done
			;;
		6)
			echo "Ingresar un PATH: "
			read RUTA
			if [ -d $RUTA ]; then
				ORDINARIO=0
				CARACTERES=0
				DIRECTORIOS=0
				LINKS=0
				BLOQUES=0
				PIPES=0
				SOCKETS=0
				ls -la $RUTA | awk '{print $1}' > list.txt
				while read linea; do
					LETRA=$(echo $linea | head -c 1)
					if [ $LETRA == '-' ];then
						ORDINARIO=$(($ORDINARIO+1))
					fi
					if [ $LETRA == 'c' ];then
						CARACTERES=$(($CARACTERES+1))
					fi
					if [ $LETRA == 'd' ];then
						DIRECTORIOS=$(($DIRECTORIOS+1))
					fi
					if [ $LETRA == 'l' ];then
						LINKS=$(($LINKS+1))
					fi
					if [ $LETRA == 'b' ];then
						BLOQUES=$(($BLOQUES+1))
					fi
					if [ $LETRA == 'p' ];then
						PIPES=$(($PIPES+1))
					fi
					if [ $LETRA == 's' ];then
						SOCKETS=$(($SOCKETS+1))
					fi
				done < list.txt
				echo "En ese PATH Hay:"
				echo "Ordinarios: $ORDINARIO"
				echo "Caracteres: $CARACTERES"
				echo "Directorios: $DIRECTORIOS"
				echo "Links: $LINKS"
				echo "Bloques: $BLOQUES"
				echo "Pipes: $PIPES"
				echo "Sockets: $SOCKETS"
				rm list.txt
			else
				echo "Ruta invalida"
			fi 
			;;
		7)
			echo "Adios $USER"
			;;
	esac
fi

