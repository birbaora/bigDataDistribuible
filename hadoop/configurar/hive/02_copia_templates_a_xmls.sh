#!/bin/bash


if [ -z "${HIVE_HOME}" ]; then
    echo "la variable HIVE_HOME no está establecida. acabando"
    exit 1;
fi

if [ -z "${HIVE_CONF_DIR}" ] ; then
    echo "la variable HIVE_CONF_DIR no está configurada. salint"
    exit 1;
fi

dirOrig=$(pwd)
cd ${HIVE_CONF_DIR}

for f in $(ls *.template ) ; do
	fich=$(echo $f | cut -d"." -f1,2) ;
	if ! [ -f $fich ] ; then
		 cp $f $fich ;
	fi 
done

cp hive-default.xml.template hive-site.xml

cd ${dirOrig}
