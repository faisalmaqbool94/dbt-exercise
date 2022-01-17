with users_with_company_id as (

select usr_ev.user_id
, usr.company_id
, usr_ev.event_datetime

from {{ ref('stg_user_event_v1') }} usr_ev
inner join {{ ref('stg_users_v1') }} usr
on usr.user_id = usr_ev.user_id

)
, member_count_per_company_over_time as (

select 
format_timestamp("%b'%g", event_datetime) activity_month -- Added the same format as it was shown in the graph but we could use any formatted or parsed version
, company_id
, count(distinct user_id) member_count

from users_with_company_id
group by 1
, 2
)
select 
activity_month
, company_id
, case
when member_count < 10 then 'tier C'
when member_count >= 10 and member_count < 50 then 'tier B'
else 'tier A'
end as company_tier
, member_count
from member_count_per_company_over_time
