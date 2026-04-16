import dataclasses
import json
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))

import pandas as pd
from kafka import KafkaProducer
from models import Crime, crime_from_row

url = "https://github.com/joyeli25/DE_Zoomcamp_Project_2025-26/releases/download/crime-data/Crimes_-_2020_20260330.csv.gz"
columns = [ 'ID', 'Case_Number', 'Date', 'Block', 'IUCR', 'Primary_Type',
       'Description', 'Location_Description', 'Arrest', 'Domestic', 'Beat',
       'District', 'Ward', 'Community_Area', 'FBI_Code', 'X_Coordinate',
       'Y_Coordinate', 'Year', 'Updated_On', 'Latitude', 'Longitude',
       'Location']

# Define proper dtypes for all columns
dtypes = {
    'ID': 'Int64',
    'Case_Number': 'object',
    'Date': 'object',  # convert to datetime after reading
    'Block': 'object',
    'IUCR': 'object',
    'Primary_Type': 'object',
    'Description': 'object',
    'Location_Description': 'object',
    'Arrest': 'bool',
    'Domestic': 'bool',
    'Beat': 'Int64',
    'District': 'Int64',
    'Ward': 'Int64',
    'Community_Area': 'Int64',  # Capital I for nullable int
    'FBI_Code': 'object',
    'X_Coordinate': 'float64',
    'Y_Coordinate': 'float64',
    'Year': 'int64',
    'Updated_On': 'object',
    'Latitude': 'float64',
    'Longitude': 'float64',
    'Location': 'object'
}

df = pd.read_csv(url, names=columns, header=0, dtype=dtypes, low_memory=False).head(1000)

def crime_serializer(crime):
    crime_dict = dataclasses.asdict(crime)
    json_str = json.dumps(crime_dict)
    return json_str.encode('utf-8')

server = 'localhost:9092'

producer = KafkaProducer(
    bootstrap_servers=[server],
    value_serializer=crime_serializer
)
t0 = time.time()

topic_name = 'chi-crimes'

for _, row in df.iterrows():
    crime = crime_from_row(row)
    producer.send(topic_name, value=crime)
    print(f"Sent: {crime}")
    time.sleep(0.01)

producer.flush()

t1 = time.time()
print(f'took {(t1 - t0):.2f} seconds')