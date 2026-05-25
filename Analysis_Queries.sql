###Total_Number of Projects based on Outcome
SELECT state, COUNT(*) AS total_projects
FROM projects
GROUP BY state
ORDER BY total_projects DESC;

## Total Number of Projects Based on Locations --


select country, count(*) as Total_projects_countrywise
from projects 
group by country
order by Total_projects_countrywise desc;

## Total Number of Projects Based on Category --

select category_id ,count(*) as total_project_catgeory_wise
from projects
group by category_id
order by total_project_catgeory_wise desc;

# Total Number of Projects Based on Category_name
select  c.name as category_name , 
p.category_id,count(ProjectID) as total_Count 
from projects as p join category as c on p.category_id = c.id 
group by category_name,p.category_id 
order by total_sales desc;

## -- Total Number of Projects By Year, Quarter & Month --
SELECT 
    YEAR(from_unixtime(created_at)) AS year,
    QUARTER(from_unixtime(created_at)) AS quarter,
    MONTHNAME(from_unixtime(created_at)) AS month,
    COUNT(*) AS total_projects
FROM 
   projects
GROUP BY 
    YEAR(from_unixtime(created_at)), 
    QUARTER(from_unixtime(created_at)), 
    MONTHNAME(from_unixtime(created_at))
ORDER BY 
    YEAR(from_unixtime(created_at)) DESC, 
    QUARTER(from_unixtime(created_at)), 
    MONTHNAME(from_unixtime(created_at)); 


SELECT 
    YEAR(from_unixtime(created_at)) AS year,
    COUNT(*) AS total_projects
FROM  projects
GROUP BY 1
ORDER BY 1;


# Total Number of Projects By Amount Raised-

SELECT 
    name AS project_name,
    state,
    goal_usd as Amount_Raised
FROM 
    projects
WHERE 
    state = 'successful'
    order by amount_raised desc;
    
  # total amount raised by Successful projects
  
    select  state ,sum(goal_usd) as Total_amount_ from projects where 
    state = 'successful'
     group by state ;
     
# to see total amount raised by Successful projects in Billions

   select  concat( round(sum(goal_usd)/1000000000,2),'B') as Total_amount_in_billions from projects where 
    state = 'successful';


## Total Number of Successful Projects By Backers --

select name as project_name,
state,
backers_count from projects 
where state = 'successful' 
order by backers_count desc;

# top 10 of Successful Projects By Backers

select project_name,
state,
backers_count, rank_1  from 
(
select name as project_name,
state,
backers_count,
rank()over(order by backers_count desc) as rank_1 
from projects
where state = 'successful'
)ranked where rank_1 <=10 ;


# top 10 of Successful Projects By Backers

select name as project_name,
state,
backers_count from projects where state = 'successful' order by backers_count desc limit 10;

#-- Average Number of Days for Successful Projects --

SELECT 
    state as project,
    round(avg(datediff(from_unixtime(successful_at), from_unixtime(created_at))),0) as avg_days_for_project
FROM 
    projects
WHERE 
    state = 'successful'
    and successful_at is not null
    and created_at is not null
    group by state
ORDER BY 
   avg_days_for_project DESC;

 #-------------- Percentage of Successful Projects Overall ----------------------#


SELECT 
   concat(
   round((COUNT(CASE WHEN state = 'successful' THEN 1 END) * 100.0 / COUNT(*)),2),'%')
   AS success_percentage
FROM 
    projects;
    
    
#---Percentage of successful projects by category

    select category_id,
    count(category_id) as Total_projects,
    sum(case when state = 'successful' then 1
else 0 
end) as successful_projects,
concat(round((sum(case when state = 'successful' then 1
else 0 
end) / count(*)) * 100,
2),'%'
) as successful_percentage
FROM 
    projects 
GROUP BY 
category_id 
ORDER BY round((sum(case when state = 'successful' then 1
else 0 
end) / count(*)) * 100,
2) DESC;
   
   #Percentage of successful projects by category name
    select c.name as category_name  , c.id as category_id,
    sum(case when state ='successful' then 1 else 0 end) as Successful_count,
    count(*) as Total_projects,
   concat( round(sum(case when state ='successful' then 1 else 0 end)/count(*) *100,2),'%') as Percentage_of_successful
   from projects p join category c
   on p.category_id=c.id
   group by category_name ,category_id
   order by round(sum(case when state ='successful' then 1 else 0 end)/count(*) *100,2) desc;
   
   
   ### percentage of projects by goal_range
   
   select * from projects;

UPDATE projects
SET goal_range = CASE
    WHEN goal_usd < 5000 THEN 'Less than $5K'
    WHEN goal_usd BETWEEN 5000 AND 20000 THEN '$5K-$20K'
    WHEN goal_usd BETWEEN 20000 AND 50000 THEN '$20K-$50K'
    WHEN goal_usd BETWEEN 50000 AND 100000 THEN '$50K-$100K'
    ELSE 'More than $100K'
END;

set sql_safe_updates=0;

select   goal_range ,
count(*) as total_projects,
sum(case when state = 'successful' then 1 else 0 end) as successful_projects,
concat(round(sum(case when state ='successful' then 1 else 0 end)/count(*) *100,2),'%') as percentage
from projects 
group by 
  goal_range 
order by round(sum(case when state ='successful' then 1 else 0 end)/count(*) *100,2) desc;

