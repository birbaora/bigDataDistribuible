#!/bin/bash

#nombres=( juan perico andres sotano fulano vengano )

cd datosEntrada || exit

nombres=$( cat notas_* | cut -d" " -f1 | sort | uniq )

echo "nombres = $nombres"

for nombre in $nombres; do
	notas=$( cat notas_* | grep $nombre | cut -d" " -f2 )
	#echo "notas de $nombre = $notas "
	max=0
	for  nota in $notas ; do
		if [ $nota -gt $max ] ; then
			max=$nota
		fi
	done
	echo "el máximo  de $nombre es $max"
done

exit
