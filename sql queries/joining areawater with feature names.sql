WITH property AS (
  -- Replace -118.4795 with your property's longitude and 34.44293 with its latitude.
  SELECT ST_SetSRID(ST_MakePoint(-118.4795, 34.44293), 4326)::geography AS geom
)
SELECT 
  aw.fullname,             -- or any attribute of the water body
  ST_Distance(p.geom, aw.geom::geography) AS distance_meters,
  ST_AsText(aw.geom) AS water_geom
FROM shape_files.areawater aw
CROSS JOIN property p
ORDER BY distance_meters
LIMIT 10;

SELECT * 
FROM shape_files.areawater 
ORDER BY gid
LIMIT 10 ;

SELECT * FROM shape_files.all_lines LIMIT 10;

SELECT * FROM shape_files.feature_names LIMIT 10;

SELECT * FROM shape_files.topological_faces_area_hydrography LIMIT 10;

SELECT 
	aw.fullname "name",
	CASE aw.mtfcc
		WHEN 'H1100' THEN 'Connector Hydrographic'
		WHEN 'H2030' THEN 'Lake/Pond Hydrographic'
		WHEN 'H2040' THEN 'Reservoir Hydrographic'
		WHEN 'H2041' THEN 'Treatment Pond Hydrographic'
		WHEN 'H2051' THEN 'Bay/Estuary/Gulf/Sound Hydrographic'
		WHEN 'H2053' THEN 'Ocean/Sea Hydrographic'
		WHEN 'H2081' THEN 'Glacier Hydrographic'
		WHEN 'H3010' THEN 'Stream/River Hydrographic'
		WHEN 'H3013' THEN 'Braided Stream Hydrographic'
		WHEN 'H3020' THEN 'Canal, Ditch, or Aqueduct'
		ELSE 'No description'
	END AS "Type",
	aw.intptlon as longitude,
	aw.intptlat as latitude,
	aw.hydroid,
	tfah.hydroid,
	al.fullname as "name",
	aw.geom
FROM shape_files.topological_faces_area_hydrography tfah
JOIN shape_files.areawater aw
ON aw.hydroid = tfah.hydroid
JOIN shape_files.all_lines al
ON al.geom = aw.geom
JOIN 
ORDER BY aw.hydroid
LIMIT 10;



SELECT 
	fn.fullname AS "FN name",
	aw.geom	
FROM shape_files.areawater aw
JOIN shape_files.feature_names fn ON aw.gid = fn.gid
LIMIT 10;


SELECT 
	aw.hydroid,
	aw.mtfcc,
	CASE aw.mtfcc
		WHEN 'H1100' THEN 'Connector Hydrographic'
		WHEN 'H2030' THEN 'Lake/Pond Hydrographic'
		WHEN 'H2040' THEN 'Reservoir Hydrographic'
		WHEN 'H2041' THEN 'Treatment Pond Hydrographic'
		WHEN 'H2051' THEN 'Bay/Estuary/Gulf/Sound Hydrographic'
		WHEN 'H2053' THEN 'Ocean/Sea Hydrographic'
		WHEN 'H2081' THEN 'Glacier Hydrographic'
		WHEN 'H3010' THEN 'Stream/River Hydrographic'
		WHEN 'H3013' THEN 'Braided Stream Hydrographic'
		WHEN 'H3020' THEN 'Canal, Ditch, or Aqueduct'
		ELSE 'No description'
	END AS "Type",
	intptlon AS "longitude",
	intptlat AS "latitude",
	ST_Distance(
	    aw.geom::geography,
    	ST_SetSRID(ST_MakePoint(-118.4795, 34.44293), 4326)::geography
  	) AS distance_meters,
	aw.geom
FROM shape_files.areawater aw
ORDER BY distance_meters
LIMIT 10;

	
