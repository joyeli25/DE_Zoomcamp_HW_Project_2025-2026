-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `chi-crime-project-491821.chi_crime_dataset.external_chi_crimes`
(
  ID INT64,
  Case_Number STRING,
  Date STRING,
  Block STRING,
  IUCR STRING,
  Primary_Type STRING,
  Description STRING,
  Location_Description STRING,
  Arrest BOOL,
  Domestic BOOL,
  Beat INT64,
  District INT64,
  Ward INT64,
  Community_Area INT64,
  FBI_Code STRING,
  X_Coordinate FLOAT64,
  Y_Coordinate FLOAT64,
  Year INT64,
  Updated_On STRING,
  Latitude FLOAT64,
  Longitude FLOAT64,
  Location STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://chi-crime-project-491821-data-bucket/Crimes_202*.csv'],
  skip_leading_rows = 1  -- Skips header row if your CSV files have headers
);

-- Check Chicago Crime data
SELECT * FROM `chi-crime-project-491821.chi_crime_dataset.external_chi_crimes` LIMIT 100;

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE chi-crime-project-491821.chi_crime_dataset.chi_crimes_non_partitioned AS
SELECT * FROM chi-crime-project-491821.chi_crime_dataset.external_chi_crimes;


-- Create a partitioned table from external table
CREATE OR REPLACE TABLE `chi-crime-project-491821.chi_crime_dataset.chi_crimes_partitioned`
PARTITION BY
  parsed_date
AS
SELECT 
  * EXCEPT(Date),
  PARSE_DATE('%m/%d/%Y', SPLIT(Date, ' ')[OFFSET(0)]) AS parsed_date
FROM `chi-crime-project-491821.chi_crime_dataset.external_chi_crimes`;
