create database casestudy_2;
show databases;
use casestudy_2;

create table users (user_id int,
				created_at varchar(20),
                company_id int,
                language char(8),
                activated_at varchar(18),
                state char(7) );
                
create table `events` (user_id int,
occured_at varchar(18),
event_type char(10),
event_name char(15),
location varchar(14),
device varchar(15),
user_type int );
                
create table email_events (user_id int,
occured_at varchar(15),
action char(18),
user_type int );

select extract(week from occured_at) as "Week Numbers", count(distinct user_id) 
as "Weekly Active Users"
from `events`
where event_type = 'engangement'
group by 1;

use casetudy_2;
select months, users, ROUND(((Users/LAG(Users, 1) OVER (ORDER BY Months)- 1)*100),2) AS "Growth in %"
from 
(
select extract(month from created_at) AS Months, COUNT(activated_at) AS Users 
from users
where activated_at NOT IN("")
GROUP BY 1
ORDER BY 1
) sub;

select count(user_id),
	   sum(case when retention_week = 1 then 1 else 0 end) as
per_week_retention
from
(
select a.user_id,
       a.sign_up_week,
       b.engagement_week,
       b.engagement_week - a.sign_up_week as retention_week
from
(
(select distinct user_id, extract(week from occured_at) as sign_up_week
from tutorial.yammer_events
where event_type = 'signup_flow'
and event_nmae = 'complete_signup'
and extract(week from occured_at)=18)a
left join
(select distinct user_id, extract(week from occured_at) as engagement_week
from tutorial.yammer_events
where event_type = 'engagement' )b
on a.user_id = b.user_id
)
group by user_id
order by 
user_id;

select
extract(year from occured_at) as year_num,
extract(week from occured_at) as week_num,
device,
count(distinct user_id) as no_of_users
from events
where event_type = 'engagment'
group by 1,2,3
order by 1,2,3;

select 
100.0 * sum(case when email_cat = 'email_opened' then 1 else 0 end)
        /sum(case when email_cat = 'email_sent' then 1 else 0 end)
as email_opening_rate,
100.0 * sum(case when email_cat = 'email_clicked' then 1 else 0  end)
        /sum(case when email_cat = 'email_sent' then 1 else 0 end)
as email_clicking_rate
from
(
select *,
case when action in ('sent_weekly_digest' , 'sent_reengagement_email')
     then 'email_sent'
     when action in ('email_open')
     then 'email_opened'
     when action in ('email_clickthrouhj')
     then 'email_clicked'
end as email_cat
from email_events
)a;