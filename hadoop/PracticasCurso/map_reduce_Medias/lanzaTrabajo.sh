hdfs dfs -mkdir /listadosNotas
hdfs dfs -put datosEntrada/* /listadosNotas
#hdfs dfs -rm /salidaMedias/*
hdfs dfs -rm -r /salidaMedias

if ! [ -f Medias.jar ] ; then
	echo "No existe Medias.jar"
	exit 1
fi
hadoop jar Medias.jar Medias  /listadosNotas  /salidaMedias

hdfs dfs -ls /salidaMedias
rm -rf ./resultado
mkdir resultado
hdfs dfs -get /salidaMedias/* ./resultado

