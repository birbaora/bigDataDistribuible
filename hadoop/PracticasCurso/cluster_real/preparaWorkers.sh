#!/bin/bash

if  ! echo $HADOOP_HOME | egrep ^/ ; then
	 echo "No existe variable \$HADOOP_HOME. Saliendo"
	exit 1
fi

workers=$(cat /etc/hosts | tail -n+3 | cut -d " " -f2)
echo "WORKERS = $workers"

rm -rf ${HADOOP_HOME}/logs

#el namenode sólo debe existir en el maestro preparamos un comando
cmd=$(cat << EOF 
	rm -rf /datos/* || \
	   echo "no borrado /datos/*" >>/home/hadoop/errores
	rm -rf ${HADOOP_HOME}/logs/*
	touch /home/hadoop/accedido
	exit
EOF
)

for nodo in $workers  ; do
	ssh hadoop@${nodo} -t  "$cmd"
done

# el datanode solo debe existir en los esclavos)
rm -rf /datos/* #(el datanode solo debe existir en los esclavos)

#start-dfs.sh

#echo "HDFS iniciado, verifica http://nodo1:9870/dfshealth.html#tab-overview"

