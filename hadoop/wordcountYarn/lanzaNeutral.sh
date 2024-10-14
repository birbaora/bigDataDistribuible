#!/bin/bash

rm palabras.txt
hdfs dfs -rm /libros/*
hdfs dfs -rmdir /libros
hdfs dfs -mkdir /libros
hdfs dfs -put ./quijote.txt /libros
hdfs dfs -ls /libros
hdfs dfs -rm /salida_libros/*
hdfs dfs -rmdir /salida_libros

fichero="/opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.4.0.jar"

test -f ${fichero} &&
        yarn jar ${fichero}  wordcount /libros /salida_libros || echo "Error no se encuentra el jar o hubo un error"


hdfs dfs -ls /salida_libros
hdfs dfs -get /salida_libros/part-r-00000 ./palabras.txt

head palabras.txt


