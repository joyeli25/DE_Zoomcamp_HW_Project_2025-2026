# Module 3 Homework: Data Warehousing & BigQuery

In this homework we'll practice working with BigQuery and Google Cloud Storage.

When submitting your homework, you will also need to include
a link to your GitHub repository or other public code-hosting
site.

This repository should contain the code for solving the homework.

When your solution has SQL or shell commands and not code
(e.g. python files) file format, include them directly in
the README file of your repository.

## Data

For this homework we will be using the Yellow Taxi Trip Records for January 2024 - June 2024 (not the entire year of data).

Parquet Files are available from the New York City Taxi Data found here:

https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page

## Loading the data

You can use the following scripts to load the data into your GCS bucket:

- Python script: [load_yellow_taxi_data.py](./load_yellow_taxi_data.py)
- Jupyter notebook with DLT: [DLT_upload_to_GCP.ipynb](./DLT_upload_to_GCP.ipynb)

You will need to generate a Service Account with GCS Admin privileges or be authenticated with the Google SDK, and update the bucket name in the script.

If you are using orchestration tools such as Kestra, Mage, Airflow, or Prefect, do not load the data into BigQuery using the orchestrator.

Make sure that all 6 files show in your GCS bucket before beginning.

Note: You will need to use the PARQUET option when creating an external table.


## BigQuery Setup

Create an external table using the Yellow Taxi Trip Records. 

Create a (regular/materialized) table in BQ using the Yellow Taxi Trip Records (do not partition or cluster this table). 



## Question 1. Counting records

What is count of records for the 2024 Yellow Taxi Data?
- ~~65,623~~
- ~~840,402~~
- 20,332,093
- ~~85,431,289~~


## Question 2. Data read estimation

Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
 
What is the **estimated amount** of data that will be read when this query is executed on the External Table and the Table?

- ~~18.82 MB for the External Table and 47.60 MB for the Materialized Table~~
- 0 MB for the External Table and 155.12 MB for the Materialized Table
- ~~2.14 GB for the External Table and 0MB for the Materialized Table~~
- ~~0 MB for the External Table and 0MB for the Materialized Table~~

> For Materialized Table

```text
Job ID
terraform-project-485722:US.bquxjob_61c0bfec_19c2b9829cc
User
**@gmail.com
Location
US
Creation time
Feb 4, 2026, 6:18:38 PM UTC-8
Start time
Feb 4, 2026, 6:18:38 PM UTC-8
End time
Feb 4, 2026, 6:18:39 PM UTC-8
Duration
0 sec
Bytes processed
155.12 MB
Bytes billed
156 MB
Slot milliseconds
398
Job priority
INTERACTIVE
Use legacy SQL
false
Destination table
Temporary table
Labels
```
> For External Table

```text
Job ID
terraform-project-485722:US.bquxjob_360be814_19c2bb4b8b7
User
**@gmail.com
Location
US
Creation time
Feb 4, 2026, 6:49:50 PM UTC-8
Start time
Feb 4, 2026, 6:49:50 PM UTC-8
End time
Feb 4, 2026, 6:49:51 PM UTC-8
Duration
0 sec
Bytes processed
155.12 MB
Bytes billed
156 MB
Slot milliseconds
4589
Job priority
INTERACTIVE
Use legacy SQL
false
Destination table
Temporary table
Metadata Cache Unused Reasons
METADATA_CACHING_NOT_ENABLED: terraform-project-485722.dezoomcamp_hw3_2026_dataset.yellow_tripdata_external
Labels
```

## Question 3. Understanding columnar storage

Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table.

Why are the estimated number of Bytes different?
- BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires 
reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.
- ~~BigQuery duplicates data across multiple storage partitions, so selecting two columns instead of one requires scanning the table twice, 
doubling the estimated bytes processed.~~
- ~~BigQuery automatically caches the first queried column, so adding a second column increases processing time but does not affect the estimated bytes scanned.~~
- ~~When selecting multiple columns, BigQuery performs an implicit join operation between them, increasing the estimated bytes processed~~

```
Job ID
terraform-project-485722:US.bquxjob_609864d4_19c2bc8a8a2
User
**@gmail.com
Location
US
Creation time
Feb 4, 2026, 7:11:37 PM UTC-8
Start time
Feb 4, 2026, 7:11:37 PM UTC-8
End time
Feb 4, 2026, 7:11:43 PM UTC-8
Duration
5 sec
Bytes processed
155.12 MB
Bytes billed
156 MB
Slot milliseconds
45646
Job priority
INTERACTIVE
Use legacy SQL
false
Destination table
Temporary table
Labels
```

```
Job ID
terraform-project-485722:US.bquxjob_34b44f47_19c2bca0b1d
User
**@gmail.com
Location
US
Creation time
Feb 4, 2026, 7:13:07 PM UTC-8
Start time
Feb 4, 2026, 7:13:07 PM UTC-8
End time
Feb 4, 2026, 7:13:14 PM UTC-8
Duration
6 sec
Bytes processed
310.24 MB
Bytes billed
311 MB
Slot milliseconds
58720
Job priority
INTERACTIVE
Use legacy SQL
false
Destination table
Temporary table
Labels
```

## Question 4. Counting zero fare trips

How many records have a fare_amount of 0?
- ~~128,210~~
- ~~546,578~~
- ~~20,188,016~~
- 8,333

```sql
SELECT count(*) FROM `terraform-project-485722.dezoomcamp_hw3_2026_dataset.yellow_tripdata_2024_01-06`
where fare_amount=0;
```

## Question 5. Partitioning and clustering

What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)

- Partition by tpep_dropoff_datetime and Cluster on VendorID
- ~~Cluster on by tpep_dropoff_datetime and Cluster on VendorID~~
- ~~Cluster on tpep_dropoff_datetime Partition by VendorID~~
- ~~Partition by tpep_dropoff_datetime and Partition by VendorID~~


## Question 6. Partition benefits

Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime
2024-03-01 and 2024-03-15 (inclusive)


Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values? 


Choose the answer which most closely matches.
 

- ~~12.47 MB for non-partitioned table and 326.42 MB for the partitioned table~~
- 310.24 MB for non-partitioned table and 26.84 MB for the partitioned table
- ~~5.87 MB for non-partitioned table and 0 MB for the partitioned table~~
- ~~310.31 MB for non-partitioned table and 285.64 MB for the partitioned table~~

```sql
SELECT distinct VendorID FROM `terraform-project-485722.dezoomcamp_hw3_2026_dataset.yellow_tripdata_2024_01-06`
where tpep_dropoff_datetime between "2024-03-01" and "2024-03-15";
```

```text
Job ID
terraform-project-485722:US.bquxjob_71276129_19c2bd60bd3
User
**@gmail.com
Location
US
Creation time
Feb 4, 2026, 7:26:14 PM UTC-8
Start time
Feb 4, 2026, 7:26:14 PM UTC-8
End time
Feb 4, 2026, 7:26:14 PM UTC-8
Duration
0 sec
Bytes processed
310.24 MB
Bytes billed
311 MB
Slot milliseconds
2055
Job priority
INTERACTIVE
Use legacy SQL
false
Destination table
Temporary table
Labels
```

```sql
CREATE OR REPLACE TABLE `terraform-project-485722.dezoomcamp_hw3_2026_dataset.yellow_tripdata_2024_01-06_partitioned_clustered`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `terraform-project-485722.dezoomcamp_hw3_2026_dataset.yellow_tripdata_2024_01-06`;

SELECT distinct VendorID FROM `terraform-project-485722.dezoomcamp_hw3_2026_dataset.yellow_tripdata_2024_01-06_partitioned_clustered`
where tpep_dropoff_datetime between "2024-03-01" and "2024-03-15";
```

```text
Job ID
terraform-project-485722:US.bquxjob_698d17e9_19c2bda76bd
User
**@gmail.com
Location
US
Creation time
Feb 4, 2026, 7:31:03 PM UTC-8
Start time
Feb 4, 2026, 7:31:03 PM UTC-8
End time
Feb 4, 2026, 7:31:04 PM UTC-8
Duration
0 sec
Bytes processed
26.84 MB
Bytes billed
27 MB
Slot milliseconds
615
Job priority
INTERACTIVE
Use legacy SQL
false
Destination table
Temporary table
Labels
```

## Question 7. External table storage

Where is the data stored in the External Table you created?

- ~~Big Query~~
- ~~ontainer Registry~~
- GCP Bucket
- ~~Big Table~~

## Question 8. Clustering best practices

It is best practice in Big Query to always cluster your data:
- ~~True~~
- False


## Question 9. Understanding table scans

No Points: Write a `SELECT count(*)` query FROM the materialized table you created. How many bytes does it estimate will be read? Why?

>Bytes processed 0 B Bytes billed 0 B Slot milliseconds 1164

>BigQuery stores row count statistics in its metadata. For COUNT(*): It doesn’t scan the actual data. It reads precomputed metadata (like total_rows in INFORMATION_SCHEMA).

```sql
SELECT count(*) FROM `terraform-project-485722.dezoomcamp_hw3_2026_dataset.yellow_tripdata_2024_01-06`;
```

```text
Job ID
terraform-project-485722:US.bquxjob_12cebab0_19c2be1a7fc
User
archerlee80@gmail.com
Location
US
Creation time
Feb 4, 2026, 7:38:55 PM UTC-8
Start time
Feb 4, 2026, 7:38:55 PM UTC-8
End time
Feb 4, 2026, 7:38:55 PM UTC-8
Duration
0 sec
Bytes processed
0 B
Bytes billed
0 B
Slot milliseconds
1164
Job priority
INTERACTIVE
Use legacy SQL
false
Destination table
Temporary table
Labels
```


## Submitting the solutions

Form for submitting: https://courses.datatalks.club/de-zoomcamp-2026/homework/hw3


## Learning in Public

We encourage everyone to share what they learned. This is called "learning in public".

Read more about the benefits [here](https://alexeyondata.substack.com/p/benefits-of-learning-in-public-and).

### Example post for LinkedIn

```
🚀 Week 3 of Data Engineering Zoomcamp by @DataTalksClub complete!

Just finished Module 3 - Data Warehousing with BigQuery. Learned how to:

✅ Create external tables from GCS bucket data
✅ Build materialized tables in BigQuery
✅ Partition and cluster tables for performance
✅ Understand columnar storage and query optimization
✅ Analyze NYC taxi data at scale

Working with 20M+ records and learning how partitioning reduces query costs!

Here's my homework solution: <LINK>

Following along with this amazing free course - who else is learning data engineering?

You can sign up here: https://github.com/DataTalksClub/data-engineering-zoomcamp/
```

### Example post for Twitter/X

```
📊 Module 3 of Data Engineering Zoomcamp done!

- BigQuery & GCS
- External vs materialized tables
- Partitioning & clustering
- Query optimization

My solution: <LINK>

Free course by @DataTalksClub: https://github.com/DataTalksClub/data-engineering-zoomcamp/
```
