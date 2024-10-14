#!/bin/bash


function asignar_propiedad(){
	nombre="$1"
	valor="$2"
	fichero="$3"
	echo buscando xmlstarlet sel -t -v "//configuration/property/name[text()=${nombre}]" 

	if xmlstarlet sel -t -v "//configuration/property/name[text()='${nombre}']" ${CONF_TMP_DIR}/${fichero} ; then
		echo "actualizando propiedad $nombre al valor $valor"
		echo xmlstarlet ed -L -u "//configuration/property/name[text()=${nombre}]/following-sibling::value[1]" -v "$valor" ${CONF_TMP_DIR}/${fichero}
		xmlstarlet ed -L -u "//configuration/property/name[text()=${nombre}]/following-sibling::value[1]" -v "$valor" ${CONF_TMP_DIR}/${fichero}
	else

		xmlstarlet ed -L -s "//configuration" -t elem -n "property" -s "//configuration/property[last()]" -t elem -n "name" -v "$nombre" ${CONF_TMP_DIR}/${fichero}
		echo xmlstarlet ed -L -s "//configuration" -t elem -n "property" -s "//configuration/property[last()]" -t elem -n "name" -v "$nombre" ${CONF_TMP_DIR}/${fichero}

		xmlstarlet ed -L -s "//configuration/property[last()]" -t elem -n "value" -v "$valor" ${CONF_TMP_DIR}/${fichero}
		echo xmlstarlet ed -L -s "//configuration/property[last()]" -t elem -n "value" -v "$valor" ${CONF_TMP_DIR}/${fichero}

	fi
}


if [ -z "${HADOOP_CONF_DIR}" ]; then
    echo "la variable HADOOP_CONF_DIR no está establecida. acabando"
    exit 1;
fi

files="core-site.xml hdfs-site.xml mapred-site.xml yarn-site.xml workers"

CONF_TMP_DIR=./confHadoopXMLFiles

echo "?Copiamos los archivos existentes de hadoop para reconfigurarlos = R "
echo "?Rescatamos una version original de los archivos = O "
echo "Otra tecla trabaja con archivos preciamente copiados a ${CONF_TMP_DIR}"
read -n1 editar

if [[ "$editar" =~ [Rr] ]] ; then 
	echo "Copiando archivos actuales"
	mkdir ${CONF_TMP_DIR} 2> /dev/null
	for fichero in $files ; do 
		if ! [ -f ${HADOOP_CONF_DIR}/${fichero}.bak ] ; then
			echo "copiando por primera vez: cp  -v ${HADOOP_CONF_DIR}/${fichero} ${HADOOP_CONF_DIR}/${fichero}.bak "
		        cp  -v ${HADOOP_CONF_DIR}/${fichero} ${HADOOP_CONF_DIR}/${fichero}.bak
		fi
        	echo cp  -v ${HADOOP_CONF_DIR}/${fichero} ${CONF_TMP_DIR}
	        cp  -v ${HADOOP_CONF_DIR}/${fichero} ${CONF_TMP_DIR}
	done
fi


if [[ "$editar" =~ [Oo] ]] ; then 
	echo "Copiando archivos originales"
	mkdir ${CONF_TMP_DIR} 2> /dev/null
	for fichero in $files ; do 
		if ! [ -f ${HADOOP_CONF_DIR}/${fichero}.bak ] ; then
			echo "No existen ficheros orginales (guardados como .bak. Saliendo"
			exit 1;
		fi
        	echo cp  -v ${HADOOP_CONF_DIR}/${fichero}.bak ${CONF_TMP_DIR}/${fichero}
	        cp  -v ${HADOOP_CONF_DIR}/${fichero}.bak ${CONF_TMP_DIR}/${fichero}
	done
fi



echo "copiado, pulsa para continuar"
read -n1 

echo " )))))))))))))))))))))) core-site.xml (((((((((((((((((((((((("
echo "introduce el nombre del elemento fs.defaultFS que sera el nodo nameNode en ejecucion en este cluster"

	h_ostname=$( hostname )
	rutaNameNode="hdfs://${h_ostname}:9000"
#read rutaNameNode
fichero="core-site.xml"

#comprobamos si existe ese valor
if xmlstarlet sel -t -v "//configuration/property/name[text()='fs.defaultFS']" ${CONF_TMP_DIR}/${fichero} ; then
	echo 	xmlstarlet ed -L -u "//configuration/property/name[text()='fs.defaultFS']/following-sibling::value[1]" -v "$rutaNameNode"${CONF_TMP_DIR}/${fichero}
	xmlstarlet ed -L -u "//configuration/property/name[text()='fs.defaultFS']/following-sibling::value[1]" -v "$rutaNameNode" ${CONF_TMP_DIR}/${fichero}
else
	#creamos el valor. primero property y name
	propiedad="name"
	valor="fs.defaultFS"
	xmlstarlet ed -L -s "//configuration" -t elem -n "property" -s "//configuration/property[last()]" -t elem -n "$propiedad" -v "$valor" ${CONF_TMP_DIR}/${fichero}
	propiedad="value"
	h_ostname=$( hostname )
	valor="hdfs://${h_ostname}:9000"
	xmlstarlet ed -L -s "//configuration/property[last()]" -t elem -n "$propiedad" -v "$valor" ${CONF_TMP_DIR}/${fichero}
	echo 	"COMANDO = xmlstarlet ed -L -s \"//configuration/property\" -t elem -n \"$propiedad\" -v \"$valor\" ${CONF_TMP_DIR}/${fichero} "

fi

xmlstarlet format --indent-spaces 2 ${CONF_TMP_DIR}/${fichero} >> temp.xml
mv temp.xml ${CONF_TMP_DIR}/${fichero}

cat ${CONF_TMP_DIR}/$fichero


echo " )))))))))))))))))))))) hdfs-site.xml (((((((((((((((((((((((("
echo "introduce el nombre del elemento dfs.replication que sera el numero de nodos donde se replica hdfs"
#read dfs_replication
dfs_replication_value=1
fichero="hdfs-site.xml"


asignar_propiedad "dfs.replication" "1" $fichero
asignar_propiedad "dfs.namenode.name.dir" "/datos/namenode" $fichero
asignar_propiedad "dfs.namenode.data.dir" "/datos/datanode" $fichero

xmlstarlet format --indent-spaces 2 ${CONF_TMP_DIR}/${fichero} >> temp.xml
mv temp.xml ${CONF_TMP_DIR}/${fichero}

cat ${CONF_TMP_DIR}/$fichero


echo "copiamos los ficheros de configuracion editados a CONF_HADOOP_DIR (S/N) ??"

read -n1 copiar

if [[ "$copiar" =~ [Ss] ]] ; then 
	for fichero in $files ; do 
		echo 	cp ./${CONF_TMP_DIR}/$fichero.xml ${HADOOP_CONF_DIR}
		cp ./${CONF_TMP_DIR}/$fichero ${HADOOP_CONF_DIR}
	done


fi

exit 1;



