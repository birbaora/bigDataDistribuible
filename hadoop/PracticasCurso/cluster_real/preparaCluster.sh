#!/bin/bash

if  ! echo $HADOOP_HOME | egrep ^/ ; then
	 echo "No existe variable \$HADOOP_HOME. Saliendo"
	exit 1
fi

rm -rf ${HADOOP_HOME}/logs


#el namenode sólo debe existir en el maestro preparamos un comando
cmd=$(cat << EOF 
	rm -rf /datos/* || \
	   echo "no borrado /datos/*" >>/home/hadoop/errores
	rm -rf /datos/* || \
	  echo "no borrado /datos/datanode/current/" >> /home/hadoop/errores
	touch /home/hadoop/accedido
	exit
EOF
)
ssh hadoop@nodo2 -t  "$cmd"
ssh hadoop@nodo3 -t  "$cmd"

# el datanode solo debe existir en los esclavos)
rm -rf /datos/* #(el datanode solo debe existir en los esclavos)

#gedit workers (aquí pondremos los nodos esclavos, en nuestro caso nodo2 y nodo 3 (uno por linia))
echo nodo2> ${HADOOP_HOME}/etc/hadoop/workers
echo nodo3>> ${HADOOP_HOME}/etc/hadoop/workers

echo "Modifica dfs.replicaton a 2"
read -s -p "Presiona para seguir con la modificacion" -n 1 dummy

fich="${HADOOP_HOME}/etc/hadoop/hdfs-site.xml"
nano $fich

for nodo in $(cat ${HADOOP_HOME}/etc/hadoop/workers) ; do
	scp $fich $nodo:$fich
done

start-dfs.sh

echo "HDFS iniciado, verifica http://nodo1:9870/dfshealth.html#tab-overview"

