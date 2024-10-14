#!/bin/bash

echo "borramos .class Medias.jar y demas"

rm -f *.class Medias.jar

echo "compilamos"
hadoop com.sun.tools.javac.Main Medias.java

echo "creamos el jar"
jar cf Medias.jar Medias*.class

