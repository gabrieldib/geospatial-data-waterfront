import os
import psycopg2

def drop_extra_indexes():
    # Connection parameters (modify as needed)
    conn_params = {
        "host": "127.0.0.1",
        "port": 5432,
        "database": "census",
        "user": "postgres",
        "password": "P@gabriel7"
    }

    # Connect to PostgreSQL
    conn = psycopg2.connect(**conn_params)
    conn.autocommit = True  # So we can run DDL without manual commit
    cur = conn.cursor()

    # Find all index names for shape_files.areawater that start with "areawater_geom_idx"
    query_find_indexes = """
        SELECT indexname
        FROM pg_indexes
        WHERE schemaname = 'shape_files'
          AND tablename = 'areawater'
          AND indexname LIKE 'areawater_geom_idx%';
    """
    cur.execute(query_find_indexes)
    rows = cur.fetchall()

    # Drop each index
    for (indexname,) in rows:
        drop_stmt = f"DROP INDEX IF EXISTS shape_files.{indexname};"
        print(f"Dropping index: {indexname}")
        cur.execute(drop_stmt)

    cur.close()
    conn.close()

if __name__ == "__main__":
    drop_extra_indexes()
 