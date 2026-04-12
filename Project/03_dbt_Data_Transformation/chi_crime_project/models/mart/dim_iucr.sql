select
IUCR as iucr,
"PRIMARY DESCRIPTION" as primary_description,
"SECONDARY DESCRIPTION" as secondary_description,
"INDEX CODE" as index_code,
ACTIVE as active
from {{ ref('iucr_code_lookup') }}