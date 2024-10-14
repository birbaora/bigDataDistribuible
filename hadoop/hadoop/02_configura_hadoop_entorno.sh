#!/bin/bash

echo "configurador inicial de hadoop una vez desempaquetado.
Pulsa una tecla para continuar"

read -n1


dir_inicial=$(pwd)
cd $HOME

echo "configurando variables de entorno en $(pwd)"

rutasJava="/etc/alternatives/jre /etc/alternatives/java /etc/alternatives/javac"

for ruta in $rutasJava ; do 
	echo "Probando ruta $ruta"
	if [ -h "$ruta" ] ; then 
		javaExecutable="$ruta"
		break;
	fi
done

echo "comando java localizado en ${javaExecutable}"
javaHome=$( readlink $javaExecutable )
echo "java localizado en  $javaHome "
javaHome=${javaHome%\/bin\/java}
read -p "indica JAVA_HOME (o pulsar intro para ${javaHome} " newJavaHome

if ! [ "$newJavaHome" == "" ] ; then 
	javaHome=${newjavahome}
#	javaHome=${javahome%"/b/java"*}
fi

echo "anyadiendo \"export JAVA_HOME=${javaHome}\" a .bashrc y ejecutándolo"
echo "export JAVA_HOME=${javaHome}" >> .bashrc
export JAVA_HOME=${javaHome}

#read -p "Este es un diálogo principal (crear main.cpp)" -n1 principal
#if  ! [[ "$principal" =~  [sSyY] ]] ; then
#	echo Hecho
#	exit 0
#fi


echo "Configuración de HADOOP_HOME. por defecto en /opt/hadoop"

hadoophome=/opt/hadoop

read -p "indica HADOOP_HOME (o pulsar intro para ${hadoophome} " newDir

if ! [ "$newDir" == "" ] ; then 
	hadoophome=${newDir}
fi

echo "añadiendo \"export HADOOP_HOME=${hadoophome}\" a .bashrc y ejecutándolo"
echo "export HADOOP_HOME=${hadoophome}" >> .bashrc
export HADOOP_HOME=${hadoophome}

echo "añadiendo \"export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin\" a .bashrc "
echo  "export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin" >>.bashrc
echo "ejecutando export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin"
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

echo "añadiendo \"export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop\" a .bashrc "
echo  "export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop" >>.bashrc
echo "ejecutando export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop"

export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

echo "===================== "
echo "PATH=$PATH"
echo "JAVA_HOME=$JAVA_HOME"
echo "HADOOP_HOME=$HADOOP_HOME"




echo "volviendo a ${dir_inicial}"
cd ${dir_inicial}

