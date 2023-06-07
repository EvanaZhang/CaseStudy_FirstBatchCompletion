USE project_data;

drop table application;

CREATE TABLE application (
	applicant_id VARCHAR(255),
	channel VARCHAR(255),
	group_name VARCHAR(255),
	city VARCHAR(255),
	event VARCHAR(255),
	event_date VARCHAR(255)
	);

/* Add a new column and set as DATE data type */
ALTER TABLE application ADD (event_date1 DATE);

/* transform event_date from varchar to date and add to the new column, then update to table 'application' */
update application
set event_date1 = cast(event_date as date);

SELECT * FROM application;
select count(*) from application;

select count(distinct applicant_id)
from application
where event = 'first_batch_completed_date'
and group_name = 'treatment';

select count(distinct applicant_id)
from application
where event = 'background_check_completed_date'
and group_name = 'treatment';



/*  Control Group Table (count of dates) */
create temporary table control
select a.applicant_id, a.event_date1, datediff(a.event_date1, f.event_date1) as date_different_from_1st_to_last
from application a
right join application b
on a.applicant_id = b.applicant_id and b.event = 'card_mailed_date'
right join application c
on a.applicant_id = c.applicant_id and c.event = 'card_activation_date'
right join application d
on a.applicant_id = d.applicant_id and d.event = 'background_check_initiated_date'
right join application e
on a.applicant_id = e.applicant_id and e.event = 'background_check_completed_date'
right join application f
on a.applicant_id = f.applicant_id and f.event = 'first_batch_completed_date'
where a.event = 'application_date' and a.group_name = 'control';

/*  Use 'CREATE VIEW' to save the control group table */
create view control_view as
select a.applicant_id, a.channel, a.group_name, a.city, a.event_date1 as application_date, b.event_date1 as card_mailed_date,c.event_date1 as card_activation_date, d.event_date1 as background_check_initiated_date,
	e.event_date1 as background_check_completed_date, f.event_date1 as first_batch_completed_date, datediff(f.event_date1, a.event_date1) as date_difference_from_1st_to_last
from application a
right join application b
on a.applicant_id = b.applicant_id and b.event = 'card_mailed_date'
right join application c
on a.applicant_id = c.applicant_id and c.event = 'card_activation_date'
right join application d
on a.applicant_id = d.applicant_id and d.event = 'background_check_initiated_date'
right join application e
on a.applicant_id = e.applicant_id and e.event = 'background_check_completed_date'
right join application f
on a.applicant_id = f.applicant_id and f.event = 'first_batch_completed_date'
where a.event = 'application_date' and a.group_name = 'control';


/* Treatment Group Table (count of dates take) */
create temporary table treatment
select a.applicant_id, a.event_date1, datediff(a.event_date1, f.event_date1) as date_different_from_1st_to_last
from application a
right join application b
on a.applicant_id = b.applicant_id and b.event = 'card_mailed_date'
right join application c
on a.applicant_id = c.applicant_id and c.event = 'card_activation_date'
right join application d
on a.applicant_id = d.applicant_id and d.event = 'background_check_initiated_date'
right join application e
on a.applicant_id = e.applicant_id and e.event = 'background_check_completed_date'
right join application f
on a.applicant_id = f.applicant_id and f.event = 'first_batch_completed_date'
where a.event = 'application_date' and a.group_name = 'treatment';

/*  Use 'CREATE VIEW' to save the treatment group table */
create view treatment_view as
select a.applicant_id, a.channel, a.group_name, a.city, a.event_date1 as application_date, b.event_date1 as card_mailed_date,c.event_date1 as card_activation_date, d.event_date1 as background_check_initiated_date,
	e.event_date1 as background_check_completed_date, f.event_date1 as first_batch_completed_date, datediff(f.event_date1, a.event_date1) as date_difference_from_1st_to_last
from application a
right join application b
on a.applicant_id = b.applicant_id and b.event = 'card_mailed_date'
right join application c
on a.applicant_id = c.applicant_id and c.event = 'card_activation_date'
right join application d
on a.applicant_id = d.applicant_id and d.event = 'background_check_initiated_date'
right join application e
on a.applicant_id = e.applicant_id and e.event = 'background_check_completed_date'
right join application f
on a.applicant_id = f.applicant_id and f.event = 'first_batch_completed_date'
where a.event = 'application_date' and a.group_name = 'treatment';

select * from control_view;
select * from treatment_view;


select count(distinct applicant_id)
from application
where orientation_completed_date > first_batch_completed_date;

drop view control_view;
drop view treatment_view;

/*drop table control;
drop table treatment; */

# To compare the two groups on avg
select round(avg(date_difference_from_1st_to_last),2) from control_view; /* 10 */
select round(avg(date_difference_from_1st_to_last),2) from treatment_view; /* 6.93 */

select count(applicant_id)
from control_view
where date_difference_from_1st_to_last < 10; /* 1370 */

select count(applicant_id)
from control_view
where date_difference_from_1st_to_last >= 10; /* 1503 */

select min(date_difference_from_1st_to_last) from control_view; /* 4 */
select *
from control_view
where date_difference_from_1st_to_last = 4
group by applicant_id;/* 8 */



select max(date_difference_from_1st_to_last) from control_view; /* 28 */
select *, count(applicant_id)
from control_view
where date_difference_from_1st_to_last = 28
group by applicant_id; /* 1 */

# Treatment Analysis

select count(applicant_id)
from treatment_view
where date_difference_from_1st_to_last < 6.93; /* 1174 */

select count(applicant_id)
from treatment_view
where date_difference_from_1st_to_last >= 6.93; /* 1297 */

select min(date_difference_from_1st_to_last) from treatment_view;
select *
from treatment_view
where date_difference_from_1st_to_last = 2
group by applicant_id;

select count(*) from application


select max(date_difference_from_1st_to_last) from treatment_view;



select * from application;
select * from control_view;
select * from treatment_view;

select count(*)
from control_view
where background_check_initiated_date < card_activation_date;

create temporary table t1 as (
select applicant_id, channel, count(*) as cnt
from application
where group_name = 'control'
and channel = 'social-media'
and event = 'first_batch_completed_date'
group by 1)

create temporary table t2 as (
select applicant_id, channel, count(*) as cnt
from application
where group_name = 'treatment'
and channel = 'social-media'
and event = 'first_batch_completed_date'
group by 1)


drop table t1;
drop table t2;


select * from control_view;

select applicant_id, first_batch_completed_date
from control_view
where date_difference_from_1st_to_last = 4;

select * from treatment_view;

select count(first_batch_completed_date) as first_batch_completion
from control_view;

select * from control_view;

select count(distinct applicant_id)
from application;
