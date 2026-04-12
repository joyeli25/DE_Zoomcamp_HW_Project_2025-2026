{{
    config(
        materialized='view',
        schema='staging',
        tags=['staging', 'chi_crime_data_all']
    )
}}


select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['ID', 'Case_Number', 'Date']) }} as crime_id,
    cast(ID as string) as id,
    cast(Case_Number as string) as case_number,
    
    -- timestamps
    cast(Date as string) as crime_date,
    cast(Updated_On as string) as updated_on,

    -- crime details
    cast(IUCR as string) as iucr,
    cast(Primary_Type as string) as primary_type,
    cast(Description as string) as description,
    cast(Location_Description as string) as location_description,

    -- boolean flags
    safe_cast(Arrest as boolean) as arrest,
    safe_cast(Domestic as boolean) as domestic,

    -- geographic / jurisdiction info
    cast(Block as string) as block,
    safe_cast(Beat as INT64) as beat,
    safe_cast(District as INT64) as district,
    safe_cast(Ward as INT64) as ward,
    safe_cast(Community_Area as INT64) as community_area,

    -- FBI classification
    cast(FBI_Code as string) as fbi_code,

    -- coordinates
    safe_cast(X_Coordinate as numeric) as x_coordinate,
    safe_cast(Y_Coordinate as numeric) as y_coordinate,
    safe_cast(Latitude as numeric) as latitude,
    safe_cast(Longitude as numeric) as longitude,
    cast(Location as string) as location
from {{ source('raw_crime_data','chi_crime_data_all') }}



-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=false) %}

  limit 100

{% endif %}