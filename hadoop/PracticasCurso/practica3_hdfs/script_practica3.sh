ls /datos || sudo mkdir /datos && sudo chown hadoop:hadoop /datos


rm -rf /datos/*
mkdir /datos/namenode
mkdir /datos/datanode

echo "lanzamos dfs format"

hdfs namenode -format

read -s -p "Pulsa para mostrar el /datos/namenode" -n 1 dummy
ls -l /datos/namenode 

