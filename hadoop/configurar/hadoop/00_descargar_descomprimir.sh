#!/bin/bash

if [ $USER != "root" ] ; then
	echo el usuairo no es root, ejecute este script con sudo
	exit 1
fi

dirActual=$(pwd)

fichero=$( ls hadoop*gz )


if [ ${fichero} == "" ] ; then
	wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz
fi

fichero=$( ls hadoop*gz )
echo "procesando $fichero"
rm -rf $HOME/_tmp_hadoop
mkdir $HOME/_tmp_hadoop
cp "$fichero" $HOME/_tmp_hadoop

cd $HOME/_tmp_hadoop
carpeta=$(tar -tf $fichero | head -n 1 | cut -d'/' -f1)
tar xfz $fichero

mv $carpeta /opt/hadoop
chown -R hadoop:hadoop /opt/hadoop

mkdir /datos
chown -R hadoop:hadoop /datos

cd $dirACtual
exit


