#!/bin/bash

if [ "$USER" != "hadoop" ] ; then
	echo "el usuario no es hadoop,saliendo"
	exit 1;
fi


echo "anyadiendo configuracion a .bashrc"
cd $HOME
confBash=$(cat << 'EOF'
	export HIVE_HOME=/opt/hadoop/hive 
	export HIVE_CONF_DIR=${HIVE_HOME}/conf 
	export PATH=$PATH:/opt/hadoop/hive/bin 
#	export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop 
EOF
)

#echo $confBash >> .bashrc
echo "$confBash" 


echo "Configuración básica como hadoop hecha. invoca el script regenera_instalacion_hive para seguir"
