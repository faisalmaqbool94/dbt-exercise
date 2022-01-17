{% set pivot_cols = dbt_utils.get_column_values(table=ref('stg_user_event_v1'), column='event_name') %}

with last_use as (
    select *
    from {{ ref('stg_user_event_v1') }}
    pivot( max(event_datetime) for event_name in (
        {% for pivot_col in pivot_cols %}
            '{{pivot_col}}' as `{{pivot_col}}_last_use`{% if not loop.last %}, {% endif%}
        {% endfor %}
        ))
)
, events_pivot as (
select
user_id 
, {{ dbt_utils.pivot('event_name', dbt_utils.get_column_values(table=ref('stg_user_event_v1'), column='event_name'), suffix='_count') }}
from {{ ref('stg_user_event_v1') }}
group by user_id)


select ep.*, lu.* except(user_id) from events_pivot ep
inner join last_use lu on ep.user_id = lu.user_id
