#!/bin/bash

cd /datos
ssh nodo2
cd /datos
rm –rf namenode (el namenode sólo debe existir en el maestro)
cd datanode
rm –rf current/
exit
ssh nodo3
cd /datos
rm –rf namenode (el namenode sólo debe existir en el maestro)
cd datanode
rm –rf current/
eixit
rm –rf datanode (el datanode solo debe existir en los esclavos)
cd /opt/hadoop/etc/hadoop/
vi core-site.xml (este no vamos a tocarlo ya que el nodo1 será el maestro)
gedit hdfs-site.xml (este si lo modificamos, en la propiedad dfs.replication pondremos el valor “2”)
scp hdfs-site.xml nodo2:/opt/Hadoop/etc/hadoop/
scp hdfs-site.xml nodo3:/opt/Hadoop/etc/hadoop/
vi mapred-site.xml (no hay que tocar nada)
vi yarn-site.xml (no hay que tocar nada, porque el maestro va a ser el nodo1)
gedit workers (aquí pondremos los nodos esclavos, en nuestro caso nodo2 y nodo 3 (uno por linia))
