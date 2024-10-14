
CONF_DIR=${HIVE_HOME}/conf

cd ${CONF_DIR}

if [ $? != 0 ] ; then
	echo "Directorio de configuración ${CONF_DIR} no existe. SALIENDO"
	exit 1;
fi


for f in $(ls *.template ) ; do
	fich=$(echo $f | cut -d"." -f1,2) ; cp $f $fich ; 
done
cp hive-default.xml.template hive-site.xml
