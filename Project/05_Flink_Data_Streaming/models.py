import json
import dataclasses
import pandas as pd
from datetime import datetime
from dataclasses import dataclass
from typing import Optional


@dataclass
class Crime:
    """Chicago crime incident data model"""
    
    # Identifiers
    ID: int
    Case_Number: str
    
    # Time information
    Date: str  # format: MM/DD/YYYY HH:MM:SS AM/PM
    Year: int
    Updated_On: str  # format: YYYY Mon DD HH:MM:SS AM/PM
    
    # Location information
    Block: str
    Location_Description: str
    Beat: Optional[int]  # Police beat
    District: Optional[int]  # Police district
    Ward: Optional[int]
    Community_Area: Optional[int]
    
    # Geographic coordinates
    X_Coordinate: Optional[float]
    Y_Coordinate: Optional[float]
    Latitude: Optional[float]
    Longitude: Optional[float]
    Location: Optional[str]  # POINT (longitude latitude)
    
    # Crime classification
    IUCR: str  # Illinois Uniform Crime Reporting code
    Primary_Type: str
    Description: str
    FBI_Code: str
    
    # Flags
    Arrest: bool
    Domestic: bool


def crime_from_row(row):
    """Convert a pandas DataFrame row to a Crime object"""
    
    # Helper function to safely convert to int (handling NaN)
    def safe_int(value):
        return int(value) if pd.notna(value) else None
    
    # Helper function to safely convert to float
    def safe_float(value):
        return float(value) if pd.notna(value) else None
    
    # Helper function to safely convert to bool
    def safe_bool(value):
        if pd.isna(value):
            return False
        if isinstance(value, bool):
            return value
        if isinstance(value, str):
            return value.upper() == 'TRUE'
        return bool(value)
    
    # Format datetime fields if they're datetime objects
    def format_datetime(value):
        if pd.isna(value):
            return None
        if isinstance(value, (pd.Timestamp, datetime)):
            return value.strftime("%m/%d/%Y %H:%M:%S")
        return str(value)
    
    def format_updated_on(value):
        if pd.isna(value):
            return None
        if isinstance(value, (pd.Timestamp, datetime)):
            return value.strftime("%Y %b %d %I:%M:%S %p")
        return str(value)
    
    return Crime(
        ID=int(row['ID']),
        Case_Number=str(row['Case_Number']),
        Date=format_datetime(row['Date']),
        Year=int(row['Year']) if pd.notna(row['Year']) else None,
        Updated_On=format_updated_on(row['Updated_On']),
        Block=str(row['Block']) if pd.notna(row['Block']) else '',
        Location_Description=str(row['Location_Description']) if pd.notna(row['Location_Description']) else '',
        Beat=safe_int(row.get('Beat')),
        District=safe_int(row.get('District')),
        Ward=safe_int(row.get('Ward')),
        Community_Area=safe_int(row.get('Community_Area')),
        X_Coordinate=safe_float(row.get('X_Coordinate')),
        Y_Coordinate=safe_float(row.get('Y_Coordinate')),
        Latitude=safe_float(row.get('Latitude')),
        Longitude=safe_float(row.get('Longitude')),
        Location=str(row['Location']) if pd.notna(row.get('Location')) else None,
        IUCR=str(row['IUCR']),
        Primary_Type=str(row['Primary_Type']),
        Description=str(row['Description']),
        FBI_Code=str(row['FBI_Code']),
        Arrest=safe_bool(row['Arrest']),
        Domestic=safe_bool(row['Domestic'])
    )


def crime_serializer(crime):
    """Serialize Crime object to JSON bytes for Kafka"""
    crime_dict = dataclasses.asdict(crime)
    # Remove None values to save space (optional)
    # crime_dict = {k: v for k, v in crime_dict.items() if v is not None}
    crime_json = json.dumps(crime_dict, default=str).encode('utf-8')
    return crime_json


def crime_deserializer(data):
    """Deserialize JSON bytes back to Crime object"""
    json_str = data.decode('utf-8')
    crime_dict = json.loads(json_str)
    
    # Convert any string 'None' or 'null' back to None
    for key, value in crime_dict.items():
        if value == 'None' or value == 'null':
            crime_dict[key] = None
    
    return Crime(**crime_dict)


# Optional: Add a function for batch processing
def crimes_from_dataframe(df):
    """Convert entire DataFrame to list of Crime objects"""
    return [crime_from_row(row) for _, row in df.iterrows()]


# Optional: Add validation helper
def validate_crime(crime):
    """Validate that a Crime object has required fields"""
    required_fields = ['ID', 'Case_Number', 'Primary_Type']
    for field in required_fields:
        if getattr(crime, field) is None:
            raise ValueError(f"Missing required field: {field}")
    return True