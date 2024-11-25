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



if [ -z "${HADOOP_CONF_DIR}" ]; then
    echo "la variable HADOOP_CONF_DIR no está establecida. acabando"
    exit 1;
fi

if [ -z "${HADOOP_HOME}" ]; then
    echo "la variable HADOOP_HOME no está establecida. acabando"
    exit 1;
fi

files="mapred-site.xml yarn-site.xml"

CONF_TMP_DIR=./confYarnXMLFiles

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

echo " )))))))))))))))))))))) mapred-site.xml (((((((((((((((((((((((("
fichero="mapred-site.xml"

asignar_propiedad "mapreduce.framework.name" "yarn" $fichero

xmlstarlet format --indent-spaces 2 ${CONF_TMP_DIR}/${fichero} >> temp.xml
mv temp.xml ${CONF_TMP_DIR}/${fichero}

cat ${CONF_TMP_DIR}/$fichero

fichero="yarn-site.xml"

echo "indica el nombre del nodo maestro"
nodo=$(hostname)

asignar_propiedad "yarn.resourcemanager.hostname" $nodo $fichero
asignar_propiedad "yarn.nodemanager.aux-services" "mapreduce_shuffle" $fichero
asignar_propiedad "yarn.nodemanager.aux-services.mapreduce_shuffle.class" "org.apache.hadoop.mapred.ShuffleHandler" $fichero


cat << EOF >rutas.txt
${HADOOP_HOME}/etc/hadoop,
${HADOOP_HOME}/share/hadoop/common/*,
${HADOOP_HOME}/share/hadoop/common/lib/*,
${HADOOP_HOME}/share/hadoop/hdfs/*,
${HADOOP_HOME}/share/hadoop/hdfs/lib/*,
${HADOOP_HOME}/share/hadoop/mapreduce/*,
${HADOOP_HOME}/share/hadoop/mapreduce/lib/*,
${HADOOP_HOME}/share/hadoop/yarn/*,
${HADOOP_HOME}/share/hadoop/yarn/lib/*
EOF

asignar_propiedad_fichero "yarn.application.classpath" rutas.txt $fichero

xmlstarlet format --indent-spaces 2 ${CONF_TMP_DIR}/${fichero} >> temp.xml
mv temp.xml ${CONF_TMP_DIR}/${fichero}

cat ${CONF_TMP_DIR}/$fichero

echo "copiamos los ficheros de configuracion editados a CONF_HADOOP_DIR (S/N) ??"

read -n1 copiar

if [[ "$copiar" =~ [Ss] ]] ; then 
        for fichero in $files ; do 
                echo    cp ./${CONF_TMP_DIR}/$fichero.xml ${HADOOP_CONF_DIR} 
                cp ./${CONF_TMP_DIR}/$fichero ${HADOOP_CONF_DIR}
        done


fi

exit 1
return ;

