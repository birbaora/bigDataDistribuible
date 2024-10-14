#!/bin/bash

if [ -z "${HIVE_HOME}" ]; then
    echo "la variable HIVE_HOME no está establecida. acabando"
    exit 1;
fi

echo "arrancamos hdfs y Preparamos las carpetas"
start-dfs.sh

hdfs dfs -rm -r /tmp
hdfs dfs -mkdir /tmp
hdfs dfs -chmod g+w /tmp
hdfs dfs -rm -r /user/hive/warehouse
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod g+w /user/hive/warehouse

echo "verifica la existencia de /user/hive/warehouse"
hdfs dfs -ls /user/hive

echo "creamos ${HIVE_HOME}/bbdd"

cd ${HIVE_HOME}
echo "creando esquema en en $(pwd)"
rm -rf bbdd
mkdir bbdd
cd bbdd

echo "haciendo:  schematool -dbType derby -initSchema"
schematool -dbType derby -initSchema

echo "Ejecuta tú mismo:
create database ejemplo;
use ejemplo;
show databases;
show tables;
"

echo "Recuerda arrancar yarn"
