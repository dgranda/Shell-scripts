#!/bin/sh
temp="$HOME/borrar"
echo ""
echo "** Adaptador de datos bancarios v0.02 **"
if [ -z "$1" ]; then
   echo "No hay fichero que adaptar."
   echo "Uso: `basename $0` fichero_original"
   echo ""
   exit
fi
# Pasar de iso-8859-15 a utf8 en formato UNIX
# Se eliminan las líneas vacías y los múltiples espacios en blanco
echo -n "Dando formato correcto al fichero... "
cat $1 | iconv -f iso-8859-15 -t utf-8 | dos2unix | sed '/^$/d' | sed 's/ \+/ /g' | sed 's/ "/"/g' > $temp
echo "OK"

# Para las líneas que tengan 5 campos separados por ";",dibujo 2;3;5;4
echo -n "Poniendo los campos en el orden adecuado... "
awk -F ";" '{ if(NF == 5)print($2";"$3";"$5";"$4);}' $temp > export_`date +%d%m%Y`.csv
echo "OK"

# Se borran los ficheros temporales
echo -n "Borrando ficheros temporales... "
if [ -a "$temp" ]; then
   rm -f $temp
fi
echo "OK"
