select 
        -- identifiers
        cast(dispatching_base_num as string) as dispatching_base_num,
        cast(PUlocationID as integer) as pickup_location_id,
        cast(DOlocationID as integer) as dropoff_location_id,

        -- timestamps
        cast(pickup_datetime as timestamp) as pickup_datetime,  -- lpep = Licensed Passenger Enhancement Program (green taxis)
        cast(dropoff_datetime as timestamp) as dropoff_datetime,

        -- trip info
        cast(SR_Flag as string) as SR_Flag,
        cast(Affiliated_base_number as string) as Affiliated_base_number
from {{ source('raw_data','fhv_tripdata')}}
-- Filter out records with null vendor_id (data quality requirement)
where dispatching_base_num is not null
