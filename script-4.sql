CREATE TABLE professional (
	professional_id serial primary key,
    first_name VARCHAR(50) ,
    last_name VARCHAR(50) ,
    sex CHAR(1) CHECK (sex IN ('F', 'M')) ,
    doj DATE ,
    currentDate DATE ,
    designation VARCHAR(100) ,
    age INTEGER ,
    salary FLOAT,
    unit VARCHAR(100) ,
    leaves_used INTEGER ,
    leaves_remaining INTEGER ,
    ratings FLOAT ,
    past_exp FLOAT 
);

--Q.1

with 
	analyst_salary as (
	select * from professional where designation = 'Analyst'
	
)
select 
	unit , round( avg(salary)) 
from 
	analyst_salary 
group by 
	unit;


--Q.2
with 
	professional_leaves as (
		select * from professional where leaves_used > 10
	)
select first_name, last_name, leaves_used from professional_leaves;



--Views
--Q.3
create view Senior_analyst as 
	select * from professional where designation = 'Senior Analyst';


SELECT *
FROM "Assignment4".senior_analyst;


--Q.4
create materialized view department_count as
	select unit, count(unit) from professional p group by unit ;

SELECT unit, count
FROM "Assignment4".department_count;


--Procedure
--Q.6
create or replace procedure update_professional_salary(
    p_first_name varchar(50),
    p_last_name varchar(50),
    p_new_salary decimal(10, 2)
)
language plpgsql
as $$
begin
    update professional
    set salary = p_new_salary
    where first_name = p_first_name and last_name = p_last_name;
end;
$$;


call update_professional_salary('OLIVE', 'ANCY', 80000);


select professional_id ,first_name, last_name, salary from professional p order by professional_id ;


--Q.7
create or replace procedure total_leaves_departments()
language plpgsql
as $$
begin
    execute 'create or replace view total_leaves as select sum(leaves_used) as total_leaves from professional';
end;
$$;


call total_leaves_departments ();

select * from "Assignment4".total_leaves;