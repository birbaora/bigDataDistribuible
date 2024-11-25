hdfs dfs -mkdir /libros
hdfs dfs -put quijote.txt /libros
hdfs dfs -rm -f /salidaLibros/*
hdfs dfs -rmdir /salidaLibros


hadoop jar ContarPalabras.jar ContarPalabras  /libros /salidaLibros

hdfs dfs -ls /salidaLibros

rm -rf /tmp/salidaLibros
mkdir /tmp/salidaLibros
hdfs dfs -get /salidaLibros/* /tmp/salidaLibros

cat /tmp/salidaLibros/*000*
