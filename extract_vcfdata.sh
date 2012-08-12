#!/bin/sh
START=`date +%s`
# Se crea el directorio destino donde se van a guardar los ficheros
DIR_DEST=$(pwd)/vcfs_`date +%d%m%Y`
mkdir $DIR_DEST
# Hay que asegurarse de que se trata de un fichero en formato UNIX
cp "$1" fileTemp
dos2unix -q fileTemp
NUM=0
while read linea; do
   # Se obtiene el campo que identifica el valor de la línea
   clave=`echo "$linea" | cut -d: -f1`
   case $clave in
      "BEGIN")
         echo $linea > $DIR_DEST/temp
         let NUM+=1
         ;;
      "N")
         echo $linea >> $DIR_DEST/temp
         fileName="`echo $linea | cut -d: -f2`"
         fileNameOrdered="`echo $fileName | cut -d\; -f2`"_"`echo $fileName | cut -d\; -f1`"
         #echo "Nombre $NUM: $fileName | $fileNameOrdered"
         ;;
      "N;ENCODING=QUOTED-PRINTABLE")
         echo $linea >> $DIR_DEST/temp
         fileName="`echo $linea | cut -d: -f2`"
         fileNameOrdered="`echo $fileName | cut -d\; -f2`"_"`echo $fileName | cut -d\; -f1`"
         #echo "Nombre $NUM: $fileName | $fileNameOrdered"
         ;;
      "END")
         echo $linea >> $DIR_DEST/temp
         mv $DIR_DEST/temp "$DIR_DEST"/"$fileNameOrdered"
         ;;
      *)
         echo $linea >> $DIR_DEST/temp
         ;;
   esac
done < fileTemp
rm -f fileTemp
END=`date +%s`
echo "Procesadas $NUM entradas en `expr $END - $START` segundos"
exit
