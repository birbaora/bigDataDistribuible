#!/bin/bash




echo "borramos .class Medias.jar y demas"

rm -f *.class Medias.jar

HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar


export HADOOP_CLASSPATH=/usr/lib/jvm/java-8-openjdk-amd64/lib/tools.jar
echo "compilamos"
${HADOOP_HOME}/bin/hadoop com.sun.tools.javac.Main Medias.java
#../hadoop-3.3.3/bin/hadoop com.sun.tools.javac.Main Medias.java

echo "creamos el jar"
jar cf Medias.jar Medias*.class

