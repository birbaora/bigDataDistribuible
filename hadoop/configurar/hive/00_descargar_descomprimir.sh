#!/bin/bash


dirActual=$(pwd)

fichero=$( ls *hive*gz )


if [ "${fichero}" == "" ] ; then
	wget  https://dlcdn.apache.org/hive/hive-4.0.1/apache-hive-4.0.1-bin.tar.gz
fi

fichero=$( ls *hive*gz )
echo "procesando $fichero"
rm -rf $HOME/_tmp_hive
mkdir $HOME/_tmp_hive
cp "$fichero" $HOME/_tmp_hive

cd $HOME/_tmp_hive
carpeta=$(tar -tf $fichero | head -n 1 | cut -d'/' -f1)
tar xfz $fichero

mv $carpeta /opt/hadoop/hive

cd $dirACtual
exit


