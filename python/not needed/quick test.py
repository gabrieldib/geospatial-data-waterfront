import os
from dotenv import load_dotenv
import psycopg2
from config import conn_params

conn = None
cursor = None

try:
    conn = psycopg2.connect(**conn_params)
    cursor = conn.cursor()

    # Query to check names and coordinates
    cursor.execute(f"""
        SELECT fullname, intptlat, intptlon 
        FROM public.{os.getenv("PG_TABLE")} 
        WHERE fullname IS NOT NULL 
        LIMIT 5;
    """)
    rows = cursor.fetchall()

    print("Sample Water Features:")
    for row in rows:
        fullname, lat, lon = row
        print(f"Name: {fullname}, Lat: {lat}, Lon: {lon}")

except psycopg2.Error as e:
    print(f"Error: {e}")

finally:
    if cursor:
        cursor.close()
    if conn:
        conn.close()