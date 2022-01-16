/* In the requirement the destination event_name_last_date is expected to be DATE...
we am just keeping the timestamp (not formatting or parsing it to be DATE), assuming we can do that in our dashboard and keep it as timestamp in case 
we need to analyze things on timezones.
If necessary, we can Extract date from timestamp with specific timezone like

extract(Date from max(case when event_name = '{{pivot_col}}' then event_datetime else null end) AT TIME ZONE "UTC") as `{{pivot_col}}_lastUse`
for line ref 18
*/
{{
    config(
        materialized = 'table'
    )
}}

% set pivot_cols = dbt_utils.get_column_values(table=ref('stg_user_event_v1'), column='event_name') %}
select 

user_id
, {% for pivot_col in pivot_cols %}
    sum(case when event_name = '{{pivot_col}}' then 1 else 0 end)  as `{{pivot_col}}_count`
    , max(case when event_name = '{{pivot_col}}' then event_datetime else null end) as `{{pivot_col}}_lastUse`
    {% if not loop.last %}, {% endif%}
{% endfor %}
from {{ ref('stg_user_event_v1') }}
where event_datetime > timestamp_sub(current_timestamp(), interval 30 day)
group by 1