#!/bin/bash

nombres=(eleutelio juan perico andres sotano fulano vengano )

registros=$( echo ${#nombres[@]})

nomfich="empleados.txt"
rm -rf $nomfich
registro=$registros
(( registro -- ))

while [ $registro -ge 0 ] ; do
	nombre=${nombres[$registro]}
	edad=$( expr $RANDOM % 100 )
	echo "${nombre},${edad}" >> ${nomfich}
	(( registro -- ))
done ;

hdfs dfs -mkdir /prueba
hdfs dfs -rm /prueba/empleados.txt
hdfs dfs -put empleados.txt /prueba
