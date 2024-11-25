create table empleados (
	nombre string,
	edad integer,
)

row format delimited
fields terminated by',';

load data local inpath '/tmp/hadoop/empleados.txt' into table empleados;

