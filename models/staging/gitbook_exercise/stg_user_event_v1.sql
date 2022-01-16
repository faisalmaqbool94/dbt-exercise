{{
    config(
        materialized = 'incremental'
    )
}}

select 
user_id
, event_name
, event_datetime
, _extracted_at
from {{ source('gb_exercise', 'user_event') }}
{% if is_incremental() %}
where
Timestamp > (select max(_extracted_at) max_extracted_at from {{ this }})
-- extracted_at > timestamp_sub(current_timestamp(), interval 3 day) -- any other condition.. 
{% endif %}
