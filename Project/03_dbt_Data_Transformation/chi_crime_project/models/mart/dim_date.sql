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
    CASE
        -- Try format: "2024 Jul 24 03:40:48 PM"
        WHEN SAFE.PARSE_TIMESTAMP('%Y %b %d %I:%M:%S %p', `Updated_On`) IS NOT NULL 
            THEN SAFE.PARSE_TIMESTAMP('%Y %b %d %I:%M:%S %p', `Updated_On`)
        -- Try format: "06/21/2025 03:54:42 PM" 
        WHEN SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', `Updated_On`) IS NOT NULL
            THEN SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', `Updated_On`)
        -- Add more format attempts if needed
        ELSE NULL  -- Or handle invalid dates as needed
    END as updated_on
from {{ source('raw_crime_data', 'chi_crime_data_all') }}
