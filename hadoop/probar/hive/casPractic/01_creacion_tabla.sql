create table deslizamientos ( 
	id bigint, fecha string , 
	hora string , 
	country string , nearest_places string , 
	hazard_type string , landslide_type string , 
	motivo string , storm_name string , fatalities bigint , 
	injuries string , source_name string , source_link string , 
	location_description string , location_accuracy string , 
	landslide_size string , photos_link string , 
	cat_src string , cat_id bigint , 
	countryname string , near string , distance double , adminname1 string , adminname2 string , 
	population bigint , countrycode string , continentcode string , key string , version string , 
	tstamp string , changeset_id string , latitude double , longitude double , geolocation string ) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ';'
