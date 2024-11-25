#!/bin/bash

#nombres=( juan perico andres sotano fulano vengano )

cd datosEntrada || exit

nombres=$( cat notas_* | cut -d" " -f1 | sort | uniq )

echo "nombres = $nombres"

for nombre in $nombres; do
	notas=$( cat notas_* | grep $nombre | cut -d" " -f2 )
	#echo "notas de $nombre = $notas "
	sum=0; cuenta=0;
	for  nota in $notas ; do
		sum=$(( $sum + $nota ))
		((cuenta++))
	done
	(( media = sum / cuenta ))
	echo "media de $nombre es $media"
done

exit
