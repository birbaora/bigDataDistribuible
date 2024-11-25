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


function asignar_propiedad_fichero(){
        nombre="$1"
        ficheroValor="$2"
        fichero="$3"
        echo buscando xmlstarlet sel -t -v "//configuration/property/name[text()=${nombre}]" 

        if xmlstarlet sel -t -v "//configuration/property/name[text()='${nombre}']" ${CONF_TMP_DIR}/${fichero} ; then
                echo "actualizando propiedad $nombre al valor del fichero ${ficheroValor}"
                echo xmlstarlet ed -L -u "//configuration/property/name[text()=${nombre}]/following-sibling::value[1]" -v "$(cat ${ficheroValor})" ${CONF_TMP_DIR}/${fichero}
                xmlstarlet ed -L -u "//configuration/property/name[text()=${nombre}]/following-sibling::value[1]" -v "$(cat ${ficheroValor})"  ${CONF_TMP_DIR}/${fichero}
        else

                xmlstarlet ed -L -s "//configuration" -t elem -n "property" -s "//configuration/property[last()]" -t elem -n "name" -v "$nombre" ${CONF_TMP_DIR}/${fichero}
                echo xmlstarlet ed -L -s "//configuration" -t elem -n "property" -s "//configuration/property[last()]" -t elem -n "name" -v "$nombre" ${CONF_TMP_DIR}/${fichero}

                xmlstarlet ed -L -s "//configuration/property[last()]" -t elem -n "value" -v "$(cat ${ficheroValor})" ${CONF_TMP_DIR}/${fichero}
                echo xmlstarlet ed -L -s "//configuration/property[last()]" -t elem -n "value" -v "$(cat ${ficheroValor})" ${CONF_TMP_DIR}/${fichero}

        fi
}



if [ -z "${HIVE_HOME}" ]; then
    echo "la variable HIVE_HOME no está establecida. acabando"
    exit 1;
fi


files="hive-site.xml"

CONF_TMP_DIR=./confHiveXMLFiles

if ! [ -d  "${CONF_TMP_DIR}" ] ; then
	mkdir "${CONF_TMP_DIR}"
fi


MAIN_CONF_DIR=${HIVE_CONF_DIR}

if ! [ -d  "${MAIN_CONF_DIR}" ] ; then
	echo "No se encuentra ruta de archivos de configuracion ${MAIN_CONF_DIR}"
	exit
fi

echo "?Copiamos los archivos existentes de hadoop para reconfigurarlos = R "
echo "?Rescatamos una version original de los archivos = O "
echo "Otra tecla trabaja con archivos preciamente copiados a ${CONF_TMP_DIR}"
read -n1 editar

if [[ "$editar" =~ [Rr] ]] ; then 
        echo "Copiando archivos actuales"
        mkdir ${CONF_TMP_DIR} 2> /dev/null
        for fichero in $files ; do 
                if ! [ -f ${MAIN_CONF_DIR}/${fichero}.bak ] ; then
                        echo "copiando por primera vez: cp  -v ${MAIN_CONF_DIR}/${fichero} ${MAIN_CONF_DIR}/${fichero}.bak "
                        cp  -v ${MAIN_CONF_DIR}/${fichero} ${MAIN_CONF_DIR}/${fichero}.bak
                fi
		if ! [ -f ${MAIN_CONF_DIR}/${fichero} ] ; then
			echo "No se encuentra el fichero ${MAIN_CONF_DIR}/${fichero}. Saliendo"
			exit 3
		fi
                echo cp  -v ${MAIN_CONF_DIR}/${fichero} ${CONF_TMP_DIR}
                cp  -v ${MAIN_CONF_DIR}/${fichero} ${CONF_TMP_DIR}
        done
fi

if [[ "$editar" =~ [Oo] ]] ; then 
        echo "Copiando archivos originales"
        mkdir ${CONF_TMP_DIR} 2> /dev/null
        for fichero in $files ; do 
                if ! [ -f ${MAIN_CONF_DIR}/${fichero}.bak ] ; then
                        echo "No existen ficheros orginales (guardados como .bak. Saliendo"
                        exit 1;
                fi
                echo cp  -v ${MAIN_CONF_DIR}/${fichero}.bak ${CONF_TMP_DIR}/${fichero}
		if ! [ -f ${MAIN_CONF_DIR}/${fichero}.bak ] ; then
                        echo "No se encuentra el fichero ${MAIN_CONF_DIR}/${fichero}.bak . Saliendo"
                        exit 3
                fi

                cp  -v ${MAIN_CONF_DIR}/${fichero}.bak ${CONF_TMP_DIR}/${fichero}
        done
fi

echo "copiado, pulsa para continuar"
read -n1 

echo " )))))))))))))))))))))) hive-site.xml (((((((((((((((((((((((("
fichero="hive-site.xml"

asignar_propiedad "system:java.io.tmpdir" "/tmp/hive/java" $fichero
asignar_propiedad "system:user.name" '${user.name}' $fichero

xmlstarlet format --indent-spaces 2 ${CONF_TMP_DIR}/${fichero} >> temp.xml
mv temp.xml ${CONF_TMP_DIR}/${fichero}

echo "Fichero ${CONF_TMP_DIR}/${fichero} no mostrado por demasiado largo"
#cat ${CONF_TMP_DIR}/$fichero

echo "copiamos los ficheros de configuracion editados a CONF_HADOOP_DIR (S/N) ??"

read -n1 copiar

if [[ "$copiar" =~ [Ss] ]] ; then 
        for fichero in $files ; do 
                echo    cp ./${CONF_TMP_DIR}/$fichero.xml ${MAIN_CONF_DIR} 
                cp ./${CONF_TMP_DIR}/$fichero ${MAIN_CONF_DIR}
        done


fi

exit 1
return ;

