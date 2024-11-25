#!/bin/bash

#echo 'hacemos export HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar' 
#export HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar
#echo "borro lo compilado"

rm -f *.class ContarPalabras.jar

echo "compilamos"
hadoop com.sun.tools.javac.Main ContarPalabras.java

echo "creamos el jar"
jar cf ContarPalabras.jar ContarPalabras*.class

