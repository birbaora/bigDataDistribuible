#!/bin/bash

echo "configurador inicial de spark una vez desempaquetado en /opt/hadoop.
Pulsa una tecla para continuar"
read -n1


if [ -z "${HADOOP_HOME}" ]; then
    echo "la variable HADOOP_HOME no est<C3><A1> establecida. acabando"
    exit 1;
else
	echo "HADOOP_HOME => ${HADOOP_HOME}"
fi


echo "=========== copia y pega las siguientes líneas despues del bloque inicial de exports==="

echo "export PATH=\${PATH}:\${HADOOP_HOME}/spark/bin:\${HADOOP_HOME}/spark/sbin"
echo "export SPARK_DIST_CLASSPATH=\$(hadoop classpath)"

