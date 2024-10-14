#!/bin/bash

if [ "$USER" != "root" ] ; then
	echo "el usuario no es root, saliendo pues no tengo permisos para hacer nada"
	exit 1;
fi


echo "Se espera que la distribucion de hive este en la raiz" 
read -s -p "Presiona para seguir con el proceso o CTRL-C para cancelar" -n 1 dummy
cd Â/

distrib=$( ls *hive*.tgz )
if [ -z "$distrib" ] ; then
	echo "No se encuentra la distribucion de hive. Saliendo"
	exit 1;
fi

echo "descomprimiendo distribucion"

tar xfz $distrib

ruta=$( find  .  -maxdepth 1  -name '*iv*' )

if [ -z "$ruta" ] ; then
	echo "No se encuentra la distribucion de hive. Saliendo"
	exit 1;
fi


echo "moviendo directorio a /opt/hive"
mv $ruta /opt/hive

chown -R hadoop:hadoop  /opt/hive

