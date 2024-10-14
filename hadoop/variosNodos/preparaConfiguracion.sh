cd /datos
ssh nodo2
	cd /datos
	read -n1 -s -p "pulse para borrar namenode. Sólo debe existir enel maestro (pulse para seguir)"
	rm –rf namenode 	
	cd datanode
	rm –rf current/
	exit
ssh nodo3
	cd /datos
	read -n1 -s -p "pulse para borrar namenode. Sólo debe existir enel maestro (pulse para seguir)"
	rm –rf namenode 	
	cd datanode
	rm –rf current/
	exit
read -n1 -s -p "pulse para borrar datanoed. Sólo deben existir en los workers (pulse para seguir)"
rm –rf datanode 
cd /opt/hadoop/etc/hadoop/

read -n1 -s -p "No hace falta tocar core-site en el maestro (pulse para seguir)"
#vi core-site.xml (este no anem a tocar-lo ja que el nodo1 serà el mestre)

read -n1 -s -p "edite hdfs-site.xml para establecer la propiedad dfs.replication en \"2\" (pulse) "
gedit /opt/hadoop/etc/hadoop/hdfs-site.xml 

read -n1 -s -p "se copia el hdfs-site.xml editado a los nodos (pulse) "
scp hdfs-site.xml nodo2:/opt/Hadoop/etc/hadoop/
scp hdfs-site.xml nodo3:/opt/Hadoop/etc/hadoop/

read -n1 -s -p "No hace falta tocar map-red.xml (pulse para seguir)"
#vi mapred-site.xml (no hi ha que tocar res)

read -n1 -s -p "No hace falta tocar yarn-site.xml porque el maestro va a ser nodo1 (pulse para seguir)"
# vi yarn-site.xml (no hi ha que tocar res, perquè el mestre va a ser el nodo1)

read -n1 -s -p "modificamos workers y añadimos dos líneas \"nodo2\" y \"nodo3\" indicnado los nodos trabajadores (pulse)"
echo nodo2 > /opt/hadoop/etc/workers
echo nodo3 >> /opt/hadoop/etc/workers
echo "" >> /opt/hadoop/etc/workers
