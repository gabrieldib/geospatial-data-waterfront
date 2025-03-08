import psycopg2
from shapely.wkt import loads

from config import conn_params

try:
    # Connect
    conn = psycopg2.connect(**conn_params)
    cursor = conn.cursor()

    # Query key columns
    query = f"""
        SELECT hydroid, fullname, mtfcc, awater, 
               ST_AsText(geom), intptlat, intptlon 
        FROM public.areawater
        LIMIT 5;
    """
    cursor.execute(query)
    rows = cursor.fetchall()

    # Process and print
    print("Water Features in St. Croix:")
    print("-" * 50)
    for row in rows:
        hydroid, fullname, mtfcc, awater, wkt_geom, lat, lon = row
        geom = loads(wkt_geom)  # Parse geometry

        print(f"Hydro ID: {hydroid}")
        print(f"Name: {fullname or 'Unnamed'}")
        print(f"Type (MTFCC): {mtfcc}")
        print(f"Water Area: {awater:,} sq meters")
        print(f"Center: ({lat}, {lon})")
        print(f"Geometry Type: {geom.geom_type}")
        print(f"Number of Polygons: {len(geom.geoms) if geom.geom_type == 'MultiPolygon' else 1}")
        print(f"Area from Geom (sq degrees): {geom.area:.6f}")
        print("-" * 50)

except psycopg2.Error as e:
    print(f"Error: {e}")

finally:
    if cursor:
        cursor.close()
    if conn:
        conn.close()