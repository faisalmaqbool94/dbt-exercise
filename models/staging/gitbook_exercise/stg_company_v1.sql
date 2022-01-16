{{
    config(
        materialized = 'incremental'
    )
}}

select 
company_id
, company_name
, created_at
, country
, _extracted_at
from {{ source('gb_exercise', 'company') }}
{% if is_incremental() %}
where
Timestamp > (select max(_extracted_at) max_extracted_at from {{ this }})
-- extracted_at > timestamp_sub(current_timestamp(), interval 3 day) -- any other condition.. 
{% endif %}
