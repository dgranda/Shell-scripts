#!/bin/bash
stat_file="$HOME/stats_ppp.log"
stat_file_raw="$HOME/stats_ppp.log_raw"
temp="$HOME/ppp_temp"
if [ -d "$temp" ]; then
   rm -rf $temp
fi
mkdir -p $temp/meses
echo "** Estadísticas de conexión PPP v0.03 **"
# Siempre se busca la info en los logs (descarto comprimidos por antiguos)
for fichero in `ls /var/log/messages* | grep -iv gz`; do
   echo "Extrayendo información de $fichero"
   cat $fichero | grep Sent | sort | uniq >> $temp/borrar
done
# verifica si se ha encontrado alguna entrada
if [ -s "$temp/borrar" ]; then
   while read linea; do
      echo "$linea" | awk '{print ($1" "$2" "$5" "$7" "$10)}' >> $temp/borrar2
   done < $temp/borrar
   cat $temp/borrar2 | sort | uniq > $temp/logs_raw

   # si hay un histórico anterior hay que juntar los datos
   if [ -a "$stat_file_raw" ]; then
      echo "Sí hay histórico anterior, juntando datos..."
      conex_old=`cat $stat_file_raw | wc -l`
      cat $stat_file_raw >> $temp/logs_raw
   else
      echo "No se ha encontrado histórico anterior"
      conex_old=0
   fi
   cat $temp/logs_raw | sort | uniq > $stat_file_raw
   conex_new=`cat $stat_file_raw | wc -l`
   ((conex_add=$conex_new-$conex_old))
   echo "Total conexiones: $conex_new | Nuevas: $conex_add"

   # se comprueba cuantos meses diferentes hay
   echo "Contabilizando datos de conexión..."
   while read linea; do
      mes=`echo $linea | awk '{print $1}'`
      echo "$linea" | awk '{print ($4+$5)}' >> $temp/meses/$mes
   done < $stat_file_raw
   echo "+++ Actualizado a `date '+%H:%M:%S %d.%m.%Y'` +++" > $stat_file
   for datos_mes in `ls $temp/meses/`; do
      total_mes=0
      total_mes_MB=0
      while read datos_con; do
         ((total_mes+=$datos_con))
      done < $temp/meses/$datos_mes
      ((total_mes_MB=$total_mes/(1024*1024)))
      #echo "Total mes (MB): $total_mes_MB"
      echo "$datos_mes: $total_mes_MB MB" >> $stat_file
   done
else
    echo "No se ha encontrado ninguna entrada en los ficheros de log"
fi
echo "Borrando ficheros temporales..."
rm -rf $temp
exit
