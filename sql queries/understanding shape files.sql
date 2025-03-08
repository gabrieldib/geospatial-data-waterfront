-- reading geometry data
SELECT ST_AsText(geom) FROM shape_files.areawater LIMIT 5;

-- simple distance example
SELECT ST_Distance(
	ST_SetSRID(ST_MakePoint(34.44293308436257, -118.47949981739889), 4326)::geography,
	geom::geography
) AS distance_in_meters
FROM shape_files.areawater
ORDER BY distance_in_meters ASC
LIMIT 10;

-- distance from a given point to each record in the table
SELECT ST_AsText(
    ST_ClosestPoint(
      geom, 
      ST_SetSRID(ST_MakePoint(-118.47949981739889, 34.44293308436257), 4326)
    )
) AS closest_point, ST_Distance(
	ST_SetSRID(ST_MakePoint(-118.47949981739889, 34.44293308436257), 4326)::geography,
    ST_ClosestPoint(
      geom, 
      ST_SetSRID(ST_MakePoint(-118.47949981739889, 34.44293308436257), 4326)
    )::geography
) AS distance_meters
FROM shape_files.areawater;

-- verifying the SRID of water geometries




