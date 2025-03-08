import pandas as pd
from sqlalchemy import create_engine

# Read Excel file
df = pd.read_excel('E:\dev\geospatial-data\data\public_housing_physical_inspection_scores_0321.xlsx')

# Create a connection string to your Postgres database
user ='postgres'
password='P%40gabriel7'
engine = create_engine(f'postgresql+psycopg2://{user}:{password}@localhost:5432/census')

# Write data to a table
df.to_sql('properties', engine, if_exists='replace', index=False)
