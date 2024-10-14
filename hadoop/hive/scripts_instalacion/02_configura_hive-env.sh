
CONF_DIR=${HIVE_HOME}/conf

cd ${CONF_DIR}

if [ $? != 0 ] ; then
	echo "Directorio de configuración ${CONF_DIR} no existe. SALIENDO"
	exit 1;
fi

if ! [ -f hive-env.sh ] ; then
	echo "hive-env.sh no existe. SALIENDO"
	exit 1;
fi
	


echo 'export HADOOP_HOME=/opt/hadoop' >> .hive-env.sh
echo 'export HIVE_CONF_DIR=/opt/hive/conf ' >> hive-env.sh