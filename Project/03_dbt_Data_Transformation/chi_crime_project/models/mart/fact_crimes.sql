{{ config(
  materialized='table',
  schema='mart',
  tags=['mart', 'fact_crimes']
) }}

select
    s.crime_id,
    s.id,
    s.case_number,
    s.updated_on,	

    s.crime_date,	
    dt.year as crime_year,
    dt.month as crime_month,
    dt.day as crime_day,
    dt.weekday as crime_weekday,

    s.iucr,
    o.primary_type,
    o.primary_description,
    o.description,
    o.secondary_description,
    o.fbi_code,
    o.index_code,
    o.active,

    s.arrest,
    s.domestic,

    s.block,
    s.beat,
    s.district,
    s.ward,
    s.community_area,

    s.location_description,
    s.x_coordinate,
    s.y_coordinate,
    s.latitude,
    s.longitude,
    s.location
from {{ source('raw_crime_data', 'chi_crime_data_all') }} s
left join {{ ref('dim_offense') }} o
  on s.iucr = o.iucr
-- left join {{ ref('dim_location') }} l
--   on {{ dbt_utils.generate_surrogate_key(['s.block', 's.beat', 's.district', 's.ward', 's.community_area']) }} = l.location_key
left join {{ ref('dim_date') }} dt
  on s.Date = dt.date