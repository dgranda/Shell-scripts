#!/bin/bash
#echo -n "Enter something: "
#read ANSWER
#echo You typed: "$ANSWER"
echo ""
echo "** Redimensionador de fotos v0.01 **"
if [ -z "$1" ]; then
   echo "No has indicado dónde están las fotos."
   echo "Uso: $0 path [resolution]"
   echo ""
   exit
else
   TEMP=`echo "$1" | cut -b1`
   if [ "$TEMP" != "\\" ]; then
      RUTA="$PWD/$1"
   else
      RUTA=$1
   fi
fi
counter=1
resolution=1152x864
if [ -z "$2" ]; then
   echo "INFO: Se utiliza la resolución por defecto: 1152x864"
else
   resolution=$2
fi
echo "Lugar: $RUTA | Resolución: $resolution"
if [ -d "$RUTA/resize_$resolution" ]; then 
   echo "WARNING: El directorio destino YA existe"
else
   mkdir $RUTA/resize_$resolution
fi
for i in `ls $RUTA/ | grep -i jpg`; do
   echo "Now working on $i - Resizing to $resolution"
   #convert -resize $resolution $RUTA/$i "$RUTA/resize_$resolution/${root}_${counter}.jpg"
   convert -resize $resolution $RUTA/$i "$RUTA/resize_$resolution/$i"
   counter=`expr $counter + 1`
done
exit
