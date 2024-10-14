hdfs dfs -rm /EntradaEmpleados/*
hdfs dfs -rmdir /EntradaEmpleados
hdfs dfs -mkdir /EntradaEmpleados
hdfs dfs -put Datos_Empleados.csv /EntradaEmpleados
hdfs dfs -rm /SalidaEmpleados/*
hdfs dfs -rm -r /SalidaEmpleados

hadoop jar Empleados.jar Empleados /EntradaEmpleados /SalidaEmpleados

hdfs dfs -ls /salidaEmpleados
rm -rf ./resultado
mkdir resultado
hdfs dfs -get /salidaEmpleados/* ./resultado

