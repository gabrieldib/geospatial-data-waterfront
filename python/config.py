import os
from dotenv import load_dotenv

load_dotenv()  # This loads variables from .env into os.environ

# Now retrieve your variables
pg_host = os.getenv("PG_HOST")
pg_port = os.getenv("PG_PORT")
pg_database = os.getenv("PG_DATABASE")
pg_table = os.getenv("PG_TABLE")
pg_user = os.getenv("PG_USER")
pg_password = os.getenv("PG_PASSWORD")

# Use these in your connection, for example with psycopg2:
conn_params = {
    "host":pg_host,
    "port":pg_port,
    "database":pg_database,
    "user":pg_user,
    "password":pg_password
}
