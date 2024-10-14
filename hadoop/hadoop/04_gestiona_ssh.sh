#!/bin/bash

echo "Este script prepara todo lo relacionado con ssh, ejecutar después de establecer los ficheros
de configuración de hadoop y la prueba final
Pulsa cualquier tecla para continuar"

dir_inicial=$(pwd)
cd $HOME/.ssh

ssh-keygen -f id_rsa -N ""
cp id_rsa.pub authorized_keys

cd ${dir_inicial}

echo "hecho, trata de hacer un ssh a este computador \" ssh $( hostname ) \" "
