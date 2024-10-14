#!/bin/bash

#nombres=( juan perico andres sotano fulano vengano )

nombres=( juan perico andres sotano fulano  )

sh -c 'ps -p $$ -o ppid=' | xargs -I'{}' readlink -f '/proc/{}/exe'

ficheros="4"
registros=15
echo -n "Creando $ficheros ficheros con $registros registros cada uno nombres usados "
for nombre in ${nombres[@]} ; do 
	echo -n " $nombre "
done
echo ""

function escribeFichero  {

	if [ "$#" -ne 1 ] ; then
		echo "ERROR en la funcion"
		return -1 
	fi

	numFich="$1"
	echo "Numero de fichero $numFich"
	rm -f notas_${numFich}
	registro=$registros

	while [ $registro -gt 0 ] ; do
		indAl=$( expr $RANDOM % ${#nombres[@]} )
		nombre=${nombres[$indAl]}
		nota=$( expr $RANDOM % 100 )
		echo "${nombre} ${nota}" >> notas_${numFich}
		(( registro -- ))
	done ;
 }

while [ ${ficheros} -gt 0 ]; do
	escribeFichero $ficheros
	(( ficheros -- ))
done

rm -rf datosEntrada
mkdir datosEntrada
mv notas_* datosEntrada
