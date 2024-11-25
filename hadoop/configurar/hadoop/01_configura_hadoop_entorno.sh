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

echo "anyadiendo \"export JAVA_HOME=${javaHome}\" a fichero temporal"
echo "export JAVA_HOME=${javaHome}" >> hadoop_bashrc_tmp_file
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


if ! [ -f  ${hadoophome}/bin/hadoop ] ; then
	echo "No encontrado ejecutable ${hadoophome}/bin/hadoop . Saliendo"
	exit 2
fi

echo "añadiendo \"export HADOOP_HOME=${hadoophome}\"  a fichero temporal"
echo "export HADOOP_HOME=${hadoophome}" >> hadoop_bashrc_tmp_file
export HADOOP_HOME=${hadoophome}

echo "añadiendo \"export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin\"  a fichero temporal "
echo  "export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin" >>hadoop_bashrc_tmp_file
echo "ejecutando export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin"
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

echo "añadiendo \"export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop\"  a fichero temporal "
echo  "export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop" >>hadoop_bashrc_tmp_file
echo "ejecutando export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop"

export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

echo "========== exported variables : =========== "
echo "PATH=$PATH"
echo "JAVA_HOME=$JAVA_HOME"
echo "HADOOP_HOME=$HADOOP_HOME"
echo "HADOOP_CONF_DIR=${HADOOP_CONF_DIR}"

echo "================ adding the following lines to bashrc ====================="

cat hadoop_bashrc_tmp_file

cat .bashrc >> hadoop_bashrc_tmp_file
mv hadoop_bashrc_tmp_file .bashrc
rm hadoop_bashrc_tmp_file




echo "volviendo a ${dir_inicial}"
cd ${dir_inicial}

