#!/bin/bash

if ! hdfs dfs -ls /spark/puertos.csv ; then
	hdfs dfs -rm -f /spark/*
	hdfs dfs -rmdir /spark
	hdfs dfs -mkdir /spark
	hdfs dfs -put ./puertos.csv /spark
fi

spark-shell -i ejemplo.scala
