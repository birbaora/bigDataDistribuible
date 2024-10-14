#!/bin/bash
# destruye y elimina todos losdatos del hdfs y vuelve a dar formato al hdfs


if [ -z "${HADOOP_CONF_DIR}" ]; then
    echo "la variable HADOOP_CONF_DIR no est<C3><A1> establecida. acabando"
    exit 1;
fi

if [ -z "${HADOOP_HOME}" ]; then
    echo "la variable HADOOP_HOME no est<C3><A1> establecida. acabando"
    exit 1;
fi


echo "destruye y elimina todos losdatos del hdfs y vuelve a dar formato al hdfs.
Pulsa una tecla para continuar"

#read -n 1

if ! [ -d /datos ] || [ $( stat -c '%U' "/datos" ) != "${USER}" ] ; then
	echo "/datos no encontrado o hadoop no es el dueño"
	exit 1;
fi

rm -rf ${HADOOP_HOME}/logs/*

rm -rf /datos/*
mkdir /datos/namenode
mkdir /datos/datanode

echo "arrancamos el demonio"
start-dfs.sh

echo "Formateamos el sistema de archivos "
hdfs namenode -format # no podemos hacerlo asi porque no esta en marcha dfs

stop-dfs.sh
start-dfs.sh

echo " arrancado start-dfs. preparamos las carpetas y datos de prueba pulsa una tecla"
#read -n 1

hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/root

hdfs dfs -mkdir /input
hdfs dfs -put ${HADOOP_CONF_DIR}/*.xml /input

echo " ya puedes lanzar hadoop "
echo './bin/hadoop jar  ....'


echo "y no olvides detener el demonio"
echo './sbin/stop-dfs.sh'

