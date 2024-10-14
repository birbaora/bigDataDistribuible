#!/bin/bash

echo "este script realiza una prueba de funcionamiento de hadoop previamente a la
configuración del mismo (antes de tocar hdfs-site.xml core-site.xml etc)"

rm -rf /tmp/input
mkdir /tmp/input
cp /opt/hadoop/etc/hadoop/*.xml /tmp/input

cd $HADOOP_HOME
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.4.0.jar grep /tmp/input /tmp/output 'dfs[a-z.]+'
