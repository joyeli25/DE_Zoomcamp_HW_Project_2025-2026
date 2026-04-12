select
    iucr,
    primary_description,
    secondary_description,
    index_code,
    active
from {{ ref('iucr_code_lookup') }}