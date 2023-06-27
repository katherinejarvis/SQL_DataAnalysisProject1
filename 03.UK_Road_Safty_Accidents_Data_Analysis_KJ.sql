-- open database
use accidents

/* Create index on accident_index as it is using in both vehicles and accident tables and join clauses using indexes will perform faster */
CREATE INDEX accident_index
ON accident(accident_index);

CREATE INDEX accident_index
ON vehicles(accident_index);

-- check out the tables in the database, determine which columns can be concatinated
-- check out # columns, rows of each
-- vehicle type=vehicle type -> code
SELECT * from accidents.accident
SELECT * from accidents.accidents_medianseverity
SELECT * from accidents.vehicle_types
SELECT * from accidents.vehicles

/* get Total Accidents and Average Severity per Vehicle Type */
SELECT vt.vehicle_type AS 'Vehicle Type', COUNT(vt.vehicle_type) AS 'Number of Accidents', AVG(a.accident_severity) as 'Average Severity'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
GROUP BY 1
ORDER BY 2,3;

Insert into accidents_median(vehicle_types, severity)
	SELECT
	  (ser.vehicle_type) as 'Vehicle Types', 
	  (ser.top + ser.bottom)/2 as Median 
	FROM
	   (SELECT  (vt.vehicle_type) as 'vehicle_type', 
			min(a.accident_severity) as bottom, max(a.accident_severity) as top
		FROM `accidents`.`vehicle_types`  vt
		Join `accidents`.`vehicles` v  ON vt.vehicle_code = v.vehicle_type
		Join `accidents`.`accident` a on v.accident_index = a.accident_index
			Group by 1) as ser
			order by 2;
            
/*check to make sure it inserted correctly*/
Select * from accidents.accidents_median;

/* Average Severity and Total Accidents by 'Good' Vehicle*/
SELECT vt.vehicle_type AS 'Vehicle Type', 
	AVG(a.accident_severity) AS 'Average Severity', 
    COUNT(vt.vehicle_type) AS 'Number of Accidents'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
WHERE vt.vehicle_type LIKE '%Good%'
GROUP BY 1
ORDER BY 2,3;