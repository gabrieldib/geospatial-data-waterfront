COPY (
	ADDRESS           TEXT,
	CITY              TEXT,	
	CBSA_NAME         TEXT,
	CBSA_CODE         INT,	
	COUNTY_NAME       TEXT,
	COUNTY_CODE       INT,
	STATE_NAME 	      TEXT,
	STATE_CODE        INT,
	ZIPCODE           INT, 
	LATITUDE          FLOAT, 
	LONGITUDE         FLOAT, 
	LOCATION_QUALITY  TEXT
)
FROM 'E:\dev\geospatial-data\data\public_housing_physical_inspection_scores_0321.csv'
WITH (FORMAT csv, HEADER true)