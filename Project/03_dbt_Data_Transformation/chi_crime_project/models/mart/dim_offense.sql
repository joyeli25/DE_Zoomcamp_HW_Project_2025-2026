{{ config(
    materialized='table',
    schema='mart',
    tags=['mart', 'dim_offense']
) }}

select distinct
    s.iucr,
    case when i.primary_description is not null then i.primary_description
         else s.primary_type
    end as primary_type,
    case when i.secondary_description is not null then i.secondary_description
         else s.description
    end as description,
    s.fbi_code,
    i.index_code,
    i.active
from {{ ref('stg_chi_crime_all') }} s
left join {{ ref('dim_iucr') }} i
    on s.iucr = case when len(i.iucr) = 4 then i.iucr else concat('0', i.iucr) end

