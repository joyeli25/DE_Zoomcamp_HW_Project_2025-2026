{{ config(
    materialized='table',
    schema='mart',
    tags=['mart', 'dim_date']
) }}

select distinct
    Date as date,  --"01/07/2026 05:17:00 PM"
    cast(PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', Date) as date) as formatted_date,
    extract(year from PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', Date)) as year,
    extract(month from PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', Date)) as month,
    extract(day from PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', Date)) as day,
    format_date('%A', cast(PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', Date) as date)) as weekday,
    cast(PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', Updated_On) as date) as updated_on
from {{ source('raw_crime_data', 'chi_crime_data_all') }}
