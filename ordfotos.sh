#!/bin/sh
echo "** Renombrador de fotos a fecha de captura v0.01 **"
if [ -z "$1" ]; then
   echo "No has proporcionado la ruta de los ficheros"
   echo "Uso: `basename $0` ruta"
   echo ""
   exit
fi
# Changing Internal Field Separator variable to prevent 'for' loops splitting with the whitespace character
OLD_IFS=$IFS
IFS=$(echo -en "\n\b")
#for i in `ls $1 | grep -i jpg`; do
for i in `find $1 -iname "*.jp*" -type f -print`; do
  if [ -f "$i" ]; then
    echo -n "Now working on $i... "
    extension=`echo "$i" | sed 's/.*\.//' | tr "[:upper:]" "[:lower:]"`
    creationDateTime=`jhead "$i" | grep Date/Time | awk '{ print $3"_"$4 }' | sed 's/://g'`
    mv "$i" "$1/$creationDateTime.$extension"
    if [ $? -eq 0 ]; then
       echo OK
    else
       echo FAIL
    fi
  else
    echo "El fichero $i no existe"
  fi
done
IFS=$OLD_IFS
exit
