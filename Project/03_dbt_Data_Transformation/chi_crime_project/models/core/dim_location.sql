{{ config(materialized='table') }}

select distinct
    {{ dbt_utils.generate_surrogate_key(['Block', 'Beat', 'District', 'Ward', '"Community_Area"']) }} as location_key,
    Block as block,
    Beat as beat,
    District as district,
    Ward as ward,
    Community_Area as community_area,
    Location_Description as location_description,
    Latitude as latitude,
    Longitude as longitude,
    X_Coordinate as x_coordinate,
    Y_Coordinate as y_coordinate
from {{ source('staging', 'chi_crime_data_all') }}
