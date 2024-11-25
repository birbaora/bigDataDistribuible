#!/bin/bash

echo "se supone creado el sistema de archivos y arrancado el demonio start-dfs.sh"

echo "creamos la carpeta input"
hdfs dfs -rm  /EjemploInputFolder/*
hdfs dfs -rmdir /EjemploInputFolder
hdfs dfs -mkdir /EjemploInputFolder

echo "limpiamos la carpeta de salida"
hdfs dfs -rm /EjemploOutputFolder/*
hdfs dfs -rmdir /EjemploOutputFolder

echo "copiamos lso ficheros fich*"
hdfs dfs -put ./datosEntrada/notas_* /EjemploInputFolder

echo "lanzamos hadoop"
yarn jar  ./Medias.jar Medias /EjemploInputFolder /EjemploOutputFolder

echo "preparamos salida y revisamos los resultados"
rm -rf output
mkdir output
hdfs dfs -get /EjemploOutputFolder ./output
hdfs dfs -cat /EjemploOutputFolder/*


echo "FINALIZADO TODO"
