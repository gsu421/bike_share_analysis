SELECT 
	f.id 				AS 'Trip ID', 
	f.duration 			AS 'Duration', 
	f.start_date 		AS 'Start Date', 
	ds1.station_name 	AS 'Start Station', 
	ds1.terminal_name 	AS 'Start Terminal', 
	f.end_date 			AS 'End Date', 
	ds2.station_name 	AS 'End Station', 
	ds2.terminal_name 	AS 'End Terminal', 
	f.bike_id 			AS 'Bike #', 
	de.enitity_type 	AS 'Subscriber Type', 
	dez.zip_code 		AS 'Zip Code'
FROM fact_trips f
INNER JOIN  dim_stations ds1 
ON f.start_station_id = ds1.id 
INNER JOIN dim_stations ds2
ON f.end_station_id = ds2.id
INNER JOIN dim_entity de 
ON f.entity_id = de.id 
INNER JOIN dim_entity_zip dez 
ON f.entity_id = dez.entity_id
WHERE f.start_date >= '3/1/2014' 
AND	  f.start_date <= '8/31/2014'