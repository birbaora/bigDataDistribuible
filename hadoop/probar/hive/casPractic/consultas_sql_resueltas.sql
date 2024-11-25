--Describimos la tabla para entender su contenido
desc deslizamientos;
----	Contamos cuantos deslizamientos se han insertado
select count(*) from deslizamientos;
--En qué país ha habido más de 100 víctimas (fatalities)
		select country,fecha, landslide_type,motivo,fatalities from
		deslizamientos where fatalities > 100;

--	Numero de deslizamientos por tipo.

	select landslide_type, count(*) from deslizamientos group by
	landslide_type;
--	Cuáles son los países 10 primeros países que tienen más movimientos registrados.

select country,count(*) as total from deslizamientos group by country
order by total desc limit 10;

--	Cantidad de deslizamientos y el motivo por Países (nombre y código)

select a.cod,b.country,b.motivo,count(*) from paises a join deslizamientos b
on a.nombre=b.country group by a.cod,b.country,b.motivo;
--	Guardamos el resultado de esta consulta en un fichero para tratarlo con herramientas externas (p.e. Excel, PowerBI…).


--escritura a fichero del resultado de una sql

insert overwrite local directory '/tmp/datos' row format delimited fields
terminated by ',' select a.cod,b.country,b.motivo,count(*) from paises a
join deslizamientos b on a.nombre=b.country group by a.cod,b.country,b.motivo;