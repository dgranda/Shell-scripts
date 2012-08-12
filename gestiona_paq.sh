#!/bin/sh

# Se establece un directorio por defecto
PATH_SCRIPT=$PWD

# Se obtiene la lista de paquetes
echo -n "Obteniendo lista de paquetes (ordenada)... "
rpm -qa | sort > ${PATH_SCRIPT}/paquetes.txt
echo "OK"

# Se manipula para obtener el nombre
echo -n "Nos quedamos con los nombres de paquetes... "
while read paquete; do
   if [ -f ${PATH_SCRIPT}/borrar ]; then
      rm -f ${PATH_SCRIPT}/borrar
   fi
   token=1
   # El nombre completo se puede dividir hasta en 5 tokens
   i=2
   #echo "Paquete: $paquete"
   while [[ ! -s ${PATH_SCRIPT}/borrar && $i -lt 6 ]]; do
      version=`echo $paquete | cut -d '-' -f$i`
      #echo "version: $version | bucle: $i"
      #echo $version | grep ^[0-9] > ${PATH_SCRIPT}/borrar
      #cat ${PATH_SCRIPT}/borrar
      let j=i-1
      token=$token",$j"
      #echo "token: $token" 
      let i+=1
   done
   echo $paquete | cut -d '-' -f$token >> ${PATH_SCRIPT}/nombres

done < ${PATH_SCRIPT}/paquetes.txt
echo "OK"

echo -n "Buscando paquetes duplicados... "
cat ${PATH_SCRIPT}/nombres | uniq -d > ${PATH_SCRIPT}/dupe.txt
echo "OK"
echo -n "Borrando ficheros temporales... "
rm -f ${PATH_SCRIPT}/nombres
rm -f ${PATH_SCRIPT}/paquetes.txt
echo "OK"

exit
