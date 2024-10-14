#!/bin/bash

echo "este script detecta la existencia de la variable de entorno \$HADOOP_CONF_DIR y si existe
la utiliza para copiar en esta carpeta los ficheros de configuración de hadoop y facilitar su
examen"

if [ -z "${HADOOP_CONF_DIR}" ] ; then
	echo HADOOP_CONF_DIR no configurada
	echo saliendo
	exit -1
fi

files="core-site.xml hdfs-site.xml mapred-site.xml yarn-site.xml workers"

for fichero in $files ; do 
	echo cp -i -v ${HADOOP_CONF_DIR}/${fichero} .
	
	cp -i -v ${HADOOP_CONF_DIR}/${fichero} .
done


