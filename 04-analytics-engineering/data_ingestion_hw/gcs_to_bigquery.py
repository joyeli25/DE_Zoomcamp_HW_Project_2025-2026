from google.cloud import bigquery, storage
import uuid

client = bigquery.Client()
storage_client = storage.Client()

dataset_id = "nytaxi"
final_table = f"{client.project}.{dataset_id}.fhv_tripdata"

bucket_name = "dezoomcamp_hw4_2026_bucket"
#prefix = "yellow/"

# Mapping to valid BigQuery CAST types
TYPE_MAPPING = {
    "FLOAT": "FLOAT64",
    "INTEGER": "INT64",
    "NUMERIC": "NUMERIC",
    "BOOLEAN": "BOOL",
    "STRING": "STRING",
    "TIMESTAMP": "TIMESTAMP",
    "DATE": "DATE",
    "DATETIME": "DATETIME",
    "TIME": "TIME"
}

def get_schema_dict(table_id):
    try:
        table = client.get_table(table_id)
        return {field.name: TYPE_MAPPING.get(field.field_type, field.field_type) for field in table.schema}
    except Exception:
        return None

# Get list of Parquet files
blobs = list(storage_client.list_blobs(bucket_name))
# parquet_files = [f"gs://{bucket_name}/{b.name}" for b in blobs if b.name.endswith(".parquet")]
csv_files = [f"gs://{bucket_name}/{b.name}" for b in blobs if b.name.endswith(".csv.gz")]

# for idx, uri in enumerate(csv_files):
for idx, uri in enumerate(csv_files):
    temp_table = f"{dataset_id}.temp_{uuid.uuid4().hex}"

    # Load into staging temp table
    job_config = bigquery.LoadJobConfig(
        # source_format=bigquery.SourceFormat.PARQUET,
        source_format=bigquery.SourceFormat.CSV,
        autodetect=True,
        write_disposition="WRITE_TRUNCATE"
    )
    print(f"Loading {uri} into {temp_table}...")
    client.load_table_from_uri(uri, temp_table, job_config=job_config).result()

    dest_schema = get_schema_dict(final_table)
    staging_schema = get_schema_dict(temp_table)

    if dest_schema is None:
        # First file creates the final table
        client.query(f"CREATE TABLE `{final_table}` AS SELECT * FROM `{temp_table}`").result()
        print(f"Created final table {final_table} from first file.")
    else:
        # Build SELECT with proper casts
        select_cols = []
        for col in dest_schema:
            if col in staging_schema:
                select_cols.append(f"CAST({col} AS {dest_schema[col]}) AS {col}")
            else:
                select_cols.append(f"NULL AS {col}")
        select_sql = ",\n  ".join(select_cols)

        insert_sql = f"""
        INSERT INTO `{final_table}`
        SELECT
          {select_sql}
        FROM `{temp_table}`
        """
        client.query(insert_sql).result()
        print(f"Inserted data from {uri} into {final_table}.")

    # Remove temp table
    client.delete_table(temp_table, not_found_ok=True)

print(f"✅ Loaded all files into {final_table}")
