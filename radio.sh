#!/bin/sh
# check http://www.listenlive.eu/spain.html
playlist_ser=""
# En el pasado la Ser intentaba complicar la vida a quien trataba de no usar su reproductor
function calcula_ser {
   fecha=`date +%Y%m%d%H%M`
   clave=`wget --referer="http://www.cadenaser.com/player_radio.html" "http://www.cadenaser.com/comunes/player/gettoken.php?update=$fecha&file=SER_LQ" -q -O - | awk -F\' '{print $2}'`
   #url="http://mfile3.akamai.com/7841/wsx/prisaffs.download.akamai.com/7807/live/_!/radios/cadenaser.asx?auth="
   playlist_ser="http://www.cadenaser.com/comunes/player/mm.php?video=SER_LQ&auth=$clave"
}

if [ -z "$1" ]; then
	echo
	echo " 1 = Cadena SER"
	echo " 2 = RNE Radio 1"
	echo " 3 = RNE Radio 3"
	echo " 4 = RNE Radio Clásica"
	echo " 5 = RNE Radio 5"
	echo " 6 = RNE Radio Exterior de Espana"
	echo " 7 = Radio Marca"
	echo " 8 = COPE"
	echo " 9 = Kiss FM"
	echo
	echo -n "Selecciona emisora: "
	read choice
else
	choice=$1
fi

if [ $choice == 1 ] ; then
# Cadena SER
#calcula_ser
#mplayer -nocache -playlist "$playlist_ser"
mplayer -nocache -playlist http://194.169.201.177:8085/liveser.mp3.m3u

elif [ $choice == 2 ] ; then
# RNE Radio 1
mplayer -nocache -playlist http://radio1.rtve.stream.flumotion.com/rtve/radio1.mp3.m3u

elif [ $choice == 3 ] ; then
# RNE Radio 3
mplayer -nocache -playlist http://radio3.rtve.stream.flumotion.com/rtve/radio3.mp3.m3u

elif [ $choice == 4 ] ; then
# RNE Clásica
mplayer -nocache -playlist http://radioclasica.rtve.stream.flumotion.com/rtve/radioclasica.mp3.m3u

elif [ $choice == 5 ] ; then
# RNE Radio 5
mplayer -nocache -playlist http://radio5.rtve.stream.flumotion.com/rtve/radio5.mp3.m3u

elif [ $choice == 6 ] ; then
# RNE Radio Exterior de Espana
mplayer -nocache -playlist http://radioexterior.rtve.stream.flumotion.com/rtve/radioexterior.mp3.m3u

elif [ $choice == 7 ] ; then
# Radio Marca
mplayer -nocache -playlist http://radioweb.radiomarcabarcelona.com:9000/stream.m3u

elif [ $choice == 8 ] ; then
# COPE
mplayer -nocache -playlist http://www.listenlive.eu/cadenacope.m3u

elif [ $choice == 9 ] ; then
# Kiss FM
mplayer -nocache -playlist http://kissfm.es.audio1.glb.ipercast.net:8000/kissfm.es/mp3.m3u

elif [ $choice == 0 ] ; then
exit 0
else echo "Esa cadena no existe"
fi
