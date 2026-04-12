{{ config(
    materialized='table',
    schema='mart',
    tags=['mart', 'dim_offense']
) }}

select distinct
    c.IUCR as iucr,
    c.Primary_Type as primary_type,
    "PRIMARY DESCRIPTION" as primary_description,
    c.Description as description,
    "SECONDARY DESCRIPTION" as secondary_description,
    c.FBI_Code as fbi_code,
    "INDEX CODE" as index_code,
    "ACTIVE" as active
from {{ source('raw_crime_data', 'chi_crime_data_all') }} c
inner join {{ ref('iucr_code_lookup') }} i
    on c.IUCR = i.IUCR

