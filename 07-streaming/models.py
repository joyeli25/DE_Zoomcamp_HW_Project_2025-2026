import json
import dataclasses
import pandas as pd

from dataclasses import dataclass


@dataclass
class Ride:
    PULocationID: int
    DOLocationID: int
    passenger_count: int
    trip_distance: float
    tip_amount: float
    total_amount: float
    lpep_pickup_datetime: str  # format: yyyy-MM-dd HH:mm:ss
    lpep_dropoff_datetime: str


# def ride_from_row(row):
#     return Ride(
#         lpep_pickup_datetime=int(row['lpep_pickup_datetime'].timestamp() * 1000),
#         lpep_dropoff_datetime=int(row['lpep_dropoff_datetime'].timestamp() * 1000),
#         PULocationID=int(row['PULocationID']),
#         DOLocationID=int(row['DOLocationID']),
#         passenger_count=0 if pd.isna(row['passenger_count']) else int(row['passenger_count']),
#         trip_distance=float(row['trip_distance']),
#         tip_amount=float(row['tip_amount']),
#         total_amount=float(row['total_amount'])
#         )
    
def ride_from_row(row):
    return Ride(
        lpep_pickup_datetime=row["lpep_pickup_datetime"].strftime("%Y-%m-%d %H:%M:%S"),
        lpep_dropoff_datetime=row["lpep_dropoff_datetime"].strftime("%Y-%m-%d %H:%M:%S"),
        PULocationID=int(row["PULocationID"]),
        DOLocationID=int(row["DOLocationID"]),
        passenger_count=0 if pd.isna(row["passenger_count"]) else int(row["passenger_count"]),
        trip_distance=float(row["trip_distance"]),
        tip_amount=float(row["tip_amount"]),
        total_amount=float(row["total_amount"])       
    )


def ride_serializer(ride):
    ride_dict = dataclasses.asdict(ride)
    ride_json = json.dumps(ride_dict).encode('utf-8')
    return ride_json


def ride_deserializer(data):
    json_str = data.decode('utf-8')
    ride_dict = json.loads(json_str)
    return Ride(**ride_dict)
