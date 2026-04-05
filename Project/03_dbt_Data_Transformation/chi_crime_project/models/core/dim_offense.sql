{{ config(materialized='table') }}

select distinct
    {{ dbt_utils.generate_surrogate_key(['IUCR', '"FBI_Code"']) }} as offense_key,
    IUCR as iucr,
    Primary_Type as primary_type,
    "Description" as description,
    FBI_Code as fbi_code
from {{ source('staging', 'chi_crime_data_all') }}

