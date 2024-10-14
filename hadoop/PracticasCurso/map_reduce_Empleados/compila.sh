#!/bin/bash

echo "borro lo compilado"
rm -f *.class Empleados.jar

echo "compilamos"
hadoop com.sun.tools.javac.Main Empleados.java

echo "creamos el jar"
jar cf Empleados.jar Empleados*.class

