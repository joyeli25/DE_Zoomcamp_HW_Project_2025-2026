{{ config(
    materialized='table',
    schema='mart',
    tags=['mart', 'dim_offense']
) }}

select distinct
    c.IUCR as iucr,
    c.Primary_Type as primary_type,
    i.primary_description,
    c.Description as description,
    i.secondary_description,
    c.FBI_Code as fbi_code,
    i.index_code,
    i.active
from {{ source('raw_crime_data', 'chi_crime_data_all') }} c
inner join {{ ref('iucr_code_lookup') }} i
    on c.IUCR = i.iucr

