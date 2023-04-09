create database casestudy_1;
show databases;
use casestudy_1;

create table job_data ( ds varchar(10), 
job_id int,
actor_id int,
`event` char(8),
language char(8),
time_spent int,
org char(1) );

Select ds, round(1.0*count(job_id)*3600/sum(time_spent),1)
as throughput
from job_data
where 
event in ('transfer','decision') and 
ds between '2020-11-01' and '2020-11-30'
GROUP BY ds;

with CTE AS (
SELECT 
DS,
COUNT(job_id) as num_jobs,
SUM(time_spent) as total_time
From job_data
Where event In ('transfer','decision')
And ds Between '2020-11-01' and '2020-11-30'
Group by ds)
Select ds,round(1.0*sum(num_jobs) over
(Order by ds rows between 6 Preceding and current row) / 
sum(total_time) OVER (order by ds rows between 6 Preceding and current row),2) as throughput_for_7days
From CTE;

   WITH CTE AS (
SELECT Language,
COUNT(job_id) as num_jobs
From job_data
Where event In('transfer','decision')
And ds Between '2020-11-01' and '2020-11-30'
Group by language),
Total as(Select COUNT(job_id) as total_jobs
From job_data
Where event In('transfer','decision')
And ds Between '2020-11-01' and '2020-11-30'
Group by language)
Select distinct Language,
Round(100*num_jobs / total_jobs,2) as percentage_of_jobs
From CTE
cross join total
Order by percentage_of_jobs DESC;                       
                          
select * from job_data;
select job_id,ds,actor_id, count(job_id) FROM JOB_DATA
group by job_id,ds,actor_id
having count(job_id)>1;					

  
                          
             
			