{{ config(
    materialized='table',
    schema='mart',
    tags=['mart', 'dim_offense']
) }}

select distinct
    {{ dbt_utils.generate_surrogate_key(['IUCR', '"FBI_Code"']) }} as offense_key,
    IUCR as iucr,
    Primary_Type as primary_type,
    "Description" as description,
    FBI_Code as fbi_code
from {{ source('raw_crime_data', 'chi_crime_data_all') }}

