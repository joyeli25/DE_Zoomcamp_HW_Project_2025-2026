{{ config(materialized='table') }}

select
    {{ dbt_utils.generate_surrogate_key(['id']) }} as crime_id,
    Case_Number as case_number,
    d.offense_key,
    l.location_key,
    dt.date_key,
    Arrest as arrest,
    Domestic as domestic
from {{ source('staging', 'chi_crime_data_all') }} s
left join {{ ref('dim_offense') }} d
  on {{ dbt_utils.generate_surrogate_key(['s.IUCR', 's.FBI_Code']) }} = d.offense_key
left join {{ ref('dim_location') }} l
  on {{ dbt_utils.generate_surrogate_key(['s.Block', 's.Beat', 's.District', 's.Ward', 's.Community_Area']) }} = l.location_key
left join {{ ref('dim_date') }} dt
  on {{ dbt_utils.generate_surrogate_key(['s.Date']) }} = dt.date_key
