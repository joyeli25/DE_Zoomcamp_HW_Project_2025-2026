select
IUCR as iucr,
PRIMARY_DESCRIPTION as primary_description,
SECONDARY_DESCRIPTION as secondary_description,
INDEX_CODE as index_code,
ACTIVE as active
from {{ ref('iucr_code_lookup') }}