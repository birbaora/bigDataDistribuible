#!/bin/bash

echo "borro lo compilado"
rm -f *.class Medias.jar

echo "compilamos"
if ! hadoop com.sun.tools.javac.Main Medias.java ; then
	echo "la compilación normal falló, vamos con javac"
	javac -classpath $( hadoop classpath) Medias.java
fi


echo "creamos el jar"
jar cf Medias.jar Medias*.class

