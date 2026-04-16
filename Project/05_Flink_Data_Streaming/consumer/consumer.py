import sys
from datetime import datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))

import psycopg2
from kafka import KafkaConsumer
from models import crime_deserializer

server = 'localhost:9092'
topic_name = 'chi-crimes'

# Connect to PostgreSQL
conn = psycopg2.connect(
    host='localhost',
    port=5433,
    database='postgres',
    user='postgres',
    password='postgres'
)
conn.autocommit = True
cur = conn.cursor()

consumer = KafkaConsumer(
    topic_name,
    bootstrap_servers=[server],
    auto_offset_reset='earliest',
    group_id='2020-crimes-consumer',
    value_deserializer=crime_deserializer
)

print(f"Listening to {topic_name} and writing to PostgreSQL...")

def create_table_if_not_exists(cur):
    """Create the processed_events table if it doesn't exist"""
    cur.execute("""
        CREATE TABLE IF NOT EXISTS processed_events (
            id INTEGER,
            case_number VARCHAR(50),
            date TIMESTAMP,
            block VARCHAR(255),
            iucr VARCHAR(10),
            primary_type VARCHAR(100),
            description TEXT,
            location_description VARCHAR(255),
            arrest BOOLEAN,
            domestic BOOLEAN,
            ward INTEGER,
            community_area INTEGER,
            fbi_code VARCHAR(10),
            x_coordinate DOUBLE PRECISION,
            y_coordinate DOUBLE PRECISION,
            year INTEGER,
            updated_on TIMESTAMP,
            latitude DOUBLE PRECISION,
            longitude DOUBLE PRECISION,
            location TEXT,
            PRIMARY KEY (id, case_number, date)  -- Composite primary key to prevent duplicates
        )
    """)
    
def clean_value(val):
    if val is None or (isinstance(val, float) and val != val):  # NaN check
        return None
    if isinstance(val, str) and val.lower() == 'nan':
        return None
    return val

create_table_if_not_exists(cur)

count = 0
for message in consumer:
    crime = message.value
    cur.execute(
        """INSERT INTO processed_events
           (id, case_number, date, block, iucr, primary_type, description,
                    location_description, arrest, domestic, ward, community_area,
                    fbi_code, x_coordinate, y_coordinate, year, updated_on,
                    latitude, longitude, location
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (id, case_number, date) DO NOTHING
            """
        , (
            clean_value(crime.ID),
            clean_value(crime.Case_Number),
            clean_value(crime.Date),
            clean_value(crime.Block),
            clean_value(crime.IUCR),
            clean_value(crime.Primary_Type),
            clean_value(crime.Description),
            clean_value(crime.Location_Description),
            clean_value(crime.Arrest),
            clean_value(crime.Domestic),
            clean_value(crime.Ward),
            clean_value(crime.Community_Area),
            clean_value(crime.FBI_Code),
            clean_value(crime.X_Coordinate),
            clean_value(crime.Y_Coordinate),
            clean_value(crime.Year),
            clean_value(crime.Updated_On),
            clean_value(crime.Latitude),
            clean_value(crime.Longitude),
            clean_value(crime.Location)
        )
    )
    count += 1
    if count % 100 == 0:
        print(f"Inserted {count} rows...")

consumer.close()
cur.close()
conn.close()