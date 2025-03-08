-- SELECT * FROM shape_files.all_lines LIMIT 10; 

-- First create an index if you don't have one already
-- CREATE INDEX IF NOT EXISTS idx_areawater_hydroid ON shape_files.areawater(hydroid);
-- CREATE INDEX IF NOT EXISTS idx_tfah_hydroid ON shape_files.topological_faces_area_hydrography(hydroid);
-- CREATE INDEX IF NOT EXISTS idx_tfah_tfid ON shape_files.topological_faces_area_hydrography(tfid);
-- CREATE INDEX IF NOT EXISTS idx_all_lines_tfidl ON shape_files.all_lines(tfidl);
-- CREATE INDEX IF NOT EXISTS idx_all_lines_tfidr ON shape_files.all_lines(tfidr);

-- Understanding how to join the tables:
-- SELECT 
--     aw.fullname AS water_name,
--     CASE aw.mtfcc
--         WHEN 'H1100' THEN 'Connector Hydrographic'
--         WHEN 'H2030' THEN 'Lake/Pond Hydrographic'
--         WHEN 'H2040' THEN 'Reservoir Hydrographic'
--         WHEN 'H2041' THEN 'Treatment Pond Hydrographic'
--         WHEN 'H2051' THEN 'Bay/Estuary/Gulf/Sound Hydrographic'
--         WHEN 'H2053' THEN 'Ocean/Sea Hydrographic'
--         WHEN 'H2081' THEN 'Glacier Hydrographic'
--         WHEN 'H3010' THEN 'Stream/River Hydrographic'
--         WHEN 'H3013' THEN 'Braided Stream Hydrographic'
--         WHEN 'H3020' THEN 'Canal, Ditch, or Aqueduct'
--         ELSE 'No description'
--     END AS water_type,
--     aw.intptlon AS longitude,
--     aw.intptlat AS latitude,
--     aw.hydroid,
--     al.fullname AS edge_name,
--     al.tlid
-- FROM shape_files.areawater aw
-- JOIN shape_files.topological_faces_area_hydrography tfah ON aw.hydroid = tfah.hydroid
-- -- Join to edges that border this face
-- JOIN shape_files.all_lines al ON (tfah.tfid = al.tfidl OR tfah.tfid = al.tfidr)
-- -- Only get edges that are water-related if needed
-- JOIN shape_files.feature_names fn ON al.tlid = fn.tlid
-- WHERE al.hydroflg = 'Y'  
-- LIMIT 10;

-- this is too slow:
-- SELECT 
--   aw.hydroid,
--   aw.fullname AS water_name,
--   fn.name AS feature_name,
--   ST_Distance(
--     aw.geom::geography, 
--     ST_SetSRID(ST_MakePoint(-118.47881536523039, 34.44268255528066), 4326)::geography
--   ) AS distance_meters
-- FROM shape_files.areawater aw
-- JOIN shape_files.topological_faces_area_hydrography tfah ON aw.hydroid = tfah.hydroid
-- JOIN shape_files.all_lines al ON (tfah.tfid = al.tfidl OR tfah.tfid = al.tfidr)
-- JOIN shape_files.feature_names fn ON al.tlid = fn.tlid
-- WHERE 
--   ST_DWithin(
--     aw.geom::geography, 
--     ST_SetSRID(ST_MakePoint(-118.47881536523039, 34.44268255528066), 4326)::geography,
--     5000  -- 5000 meters radius
--   )
-- ORDER BY distance_meters
-- LIMIT 10;


-- this query gives multiple records of the same hydroid:
-- Step 1: Find closest water bodies using geometry (fast)
-- DROP TABLE IF EXISTS closest_water;
-- CREATE TEMPORARY TABLE closest_water AS
-- SELECT 
--   aw.hydroid,
--   aw.fullname AS water_name,
--   aw.geom,
--   ST_Distance(
--     aw.geom, 
--     ST_SetSRID(ST_MakePoint(-118.47881536523039, 34.44268255528066), 4326)
--   ) AS distance_degrees
-- FROM shape_files.areawater aw
-- WHERE 
--   ST_DWithin(
--     aw.geom, 
--     ST_SetSRID(ST_MakePoint(-118.47881536523039, 34.44268255528066), 4326),
--     0.05  -- approximately 5km
--   )
-- ORDER BY distance_degrees
-- LIMIT 20;

-- -- Step 2: Join to get feature names
-- SELECT 
--   cw.hydroid,
--   cw.water_name,
--   fn.name AS feature_name,
--   -- Convert to approximate meters (at this latitude)
--   cw.distance_degrees * 111139 AS distance_meters
-- FROM closest_water cw
-- JOIN shape_files.topological_faces_area_hydrography tfah ON cw.hydroid = tfah.hydroid
-- JOIN shape_files.all_lines al ON (tfah.tfid = al.tfidl OR tfah.tfid = al.tfidr)
-- JOIN shape_files.feature_names fn ON al.tlid = fn.tlid
-- ORDER BY cw.distance_degrees
-- LIMIT 20;


-- Step 1: Find closest water bodies using geometry (fast)
DROP TABLE IF EXISTS closest_water;
CREATE TEMPORARY TABLE closest_water AS
SELECT 
  aw.hydroid,
  aw.fullname AS water_name,
  aw.geom,
  ST_Distance(
    aw.geom, 
    ST_SetSRID(ST_MakePoint(-118.47881536523039, 34.44268255528066), 4326)
  ) AS distance_degrees
FROM shape_files.areawater aw
WHERE 
  ST_DWithin(
    aw.geom, 
    ST_SetSRID(ST_MakePoint(-118.47881536523039, 34.44268255528066), 4326),
    0.1  -- Increased to get more water bodies
  )
ORDER BY distance_degrees
LIMIT 100;  -- Get more candidates to ensure variety

-- Step 2: Join to get feature names, one row per hydroid
-- Using a CTE for clarity
WITH distinct_features AS (
  SELECT DISTINCT ON (cw.hydroid)
    cw.hydroid,
    cw.water_name,
    COALESCE(fn.name, 'Unnamed water body') AS feature_name,
    ROUND(CAST(cw.distance_degrees AS numeric )* 111139,2) AS distance_meters,
    cw.distance_degrees  -- Keep this for sorting
  FROM closest_water cw
  JOIN shape_files.topological_faces_area_hydrography tfah ON cw.hydroid = tfah.hydroid
  JOIN shape_files.all_lines al ON (tfah.tfid = al.tfidl OR tfah.tfid = al.tfidr)
  JOIN shape_files.feature_names fn ON al.tlid = fn.tlid
  ORDER BY cw.hydroid, 
    CASE WHEN fn.name IS NULL THEN 2 ELSE 1 END  -- Prioritize non-null names
)
-- Now select from this and order by distance
SELECT 
  hydroid,
  water_name,
  feature_name,
  distance_meters
FROM distinct_features
ORDER BY distance_degrees
LIMIT 20;