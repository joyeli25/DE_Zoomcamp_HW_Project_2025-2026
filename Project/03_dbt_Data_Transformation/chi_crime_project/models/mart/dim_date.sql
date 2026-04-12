{{ config(
    materialized='table',
    schema='mart',
    tags=['mart', 'dim_date']
) }}

select distinct
    crime_date,  --"01/07/2026 05:17:00 PM"
    FORMAT_TIMESTAMP('%m/%d/%Y %H:%M:%S', SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p',crime_date)) as formatted_date,
    extract(year from PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', crime_date)) as year,
    extract(month from PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', crime_date)) as month,
    extract(day from PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', crime_date)) as day,
    format_date('%A', cast(PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', crime_date) as date)) as weekday,
    CASE
    -- Try format: "2024 Jul 24 03:40:48 PM"
    WHEN SAFE.PARSE_TIMESTAMP('%Y %b %d %I:%M:%S %p', updated_on) IS NOT NULL 
        THEN FORMAT_TIMESTAMP('%m/%d/%Y %H:%M:%S', SAFE.PARSE_TIMESTAMP('%Y %b %d %I:%M:%S %p', updated_on))
    -- Try format: "06/21/2025 03:54:42 PM" 
    WHEN SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', updated_on) IS NOT NULL
        THEN FORMAT_TIMESTAMP('%m/%d/%Y %H:%M:%S', SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', updated_on))
    -- Add more format attempts if needed
    ELSE NULL  -- Or handle invalid dates as needed
    END as updated_on
from {{ ref('stg_chi_crime_all') }}
