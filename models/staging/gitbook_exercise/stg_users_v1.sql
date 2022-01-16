{{
    config(
        materialized = 'incremental'
    )
}}

select 
user_id
, company_id
, username
, displayName
, user_signed_time
, user_leaved_time
, email
, country
, _extracted_at
from {{ source('gb_exercise', 'users') }}
{% if is_incremental() %}
where
Timestamp > (select max(_extracted_at) max_extracted_at from {{ this }})
-- extracted_at > timestamp_sub(current_timestamp(), interval 3 day) -- any other condition.. 
{% endif %}
