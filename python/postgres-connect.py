import os
import psycopg2
from config import conn_params

try:
    # Connect to the database
    conn = psycopg2.connect(**conn_params)
    cursor = conn.cursor()

    # Simple query to test the connection
    cursor.execute(f"SELECT gid, ST_AsText(geom) FROM public.{os.getenv("PG_TABLE")}  LIMIT 5;")
    rows = cursor.fetchall()

    # Print results
    for row in rows:
        fullid, geom = row
        print(f"G ID: {fullid}, Geometry: {geom}")

except psycopg2.Error as e:
    print(f"Error connecting to the database: {e}")

finally:
    # Clean up
    if cursor:
        cursor.close()
    if conn:
        conn.close()