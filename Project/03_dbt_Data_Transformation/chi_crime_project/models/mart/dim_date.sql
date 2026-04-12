{{ config(
    materialized='table',
    schema='mart',
    tags=['mart', 'dim_date']
) }}

select distinct
    crime_date,  --"01/07/2026 05:17:00 PM"
    cast(PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', crime_date) as date) as formatted_date,
    extract(year from PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', crime_date)) as year,
    extract(month from PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', crime_date)) as month,
    extract(day from PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', crime_date)) as day,
    format_date('%A', cast(PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', crime_date) as date)) as weekday
from {{ ref('stg_chi_crime_all') }}
