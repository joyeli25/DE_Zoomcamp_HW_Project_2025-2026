{{ config(
  materialized='table',
  schema='mart',
  tags=['mart', 'fact_crimes']
) }}

select
    s.crime_id,
    s.id,
    s.case_number,
    dt.formatted_updated_on as updated_on,

    dt.formatted_crime_date as crime_date,
    dt.year as crime_year,
    dt.month as crime_month,
    dt.day as crime_day,
    dt.weekday as crime_weekday,

    s.iucr,
    o.primary_type,
    o.description,
    s.fbi_code,
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
from {{ ref('stg_chi_crime_all') }} s
left join {{ ref('dim_offense') }} o
  on s.iucr = o.iucr
left join {{ ref('dim_date') }} dt
  on s.crime_date = dt.crime_date