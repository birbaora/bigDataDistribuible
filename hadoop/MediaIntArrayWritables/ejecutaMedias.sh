#!/bin/bash

echo "se supone creado el sistema de archivos y arrancado el demonio start-dfs.sh"

echo "creamos la carpeta input"
../hadoop-3.3.3/bin/hdfs dfs -rm -r EjemploInputFolder
../hadoop-3.3.3/bin/hdfs dfs -mkdir EjemploInputFolder

echo "limpiamos la carpeta de salida"
../hadoop-3.3.3/bin/hdfs dfs -rm -r EjemploOutputFolder

echo "copiamos lso ficheros fich*"
../hadoop-3.3.3/bin/hdfs dfs -put ./datosEntrada/notas_* EjemploInputFolder

echo "borramos log"
rm -f ../hadoop-3.3.3/logs/hadoop.log
echo "lanzamos hadoop"
../hadoop-3.3.3/bin/hadoop jar  ./Medias.jar Medias EjemploInputFolder EjemploOutputFolder

echo "preparamos salida y revisamos los resultados"
rm -rf output
mkdir output
../hadoop-3.3.3/bin/hdfs dfs -get EjemploOutputFolder ./output
../hadoop-3.3.3/bin/hdfs dfs -cat EjemploOutputFolder/*


echo "FINALIZADO TODO"
