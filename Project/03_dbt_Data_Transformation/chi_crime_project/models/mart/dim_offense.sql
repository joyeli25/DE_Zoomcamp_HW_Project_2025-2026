{{ config(
    materialized='table',
    schema='mart',
    tags=['mart', 'dim_offense']
) }}

select distinct
    s.iucr,
    s.primary_type,
    -- i.primary_description,
    s.description as description,
    -- i.secondary_description,
    s.fbi_code,
    i.index_code,
    i.active
from {{ ref('stg_chi_crime_all') }} s
inner join {{ ref('dim_iucr') }} i
    on s.iucr = i.iucr

