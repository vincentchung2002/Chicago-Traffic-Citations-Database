use chicago_traffic_citations;
 -- Number of tickets per vehicle make
create view queryone as
select v.Vehicle_Make, count(t.Ticket_number) as "Number of Tickets"
from Vehicle v
join tickets_vehicle t using(Vehicle_ID)
group by v.Vehicle_Make
order by v.Vehicle_Make;

-- Number of tickets per violation code split by plate types
create view querytwo as
select v.Violation_Code, v.Violation_Description, vh.License_Plate_Type, count(*) as "Number of Tickets"
from tickets t
join tickets_vehicle tv using(Ticket_number)
join vehicle vh using(Vehicle_ID)
join tickets_violations tvl using(Ticket_number)
join violations v using(Violation_ID)
where vh.License_Plate_Type = "pas"
group by v.Violation_Code, v.Violation_Description, vh.License_Plate_Type;

-- Average amount paid based on police unit
create view querythree as
select t.Unit, concat("$", format(avg(f.`Total Payments`), 2))  as "Average Payment"
from tickets t
join ticket_fine_amounts tf using(Ticket_Number)
join fine_amounts f using(Fine_Amount_ID)
group by t.Unit
order by t.Unit;

-- Tickets that have money owed
create view queryfour as
select t.Ticket_Number, t.Ticket_Queue_Date, t.Zip_Code, t.Unit, t.Unit_Description, concat("$", format(f.Current_Amount_Due, 2))  as "Amount Due"
from tickets t
join ticket_fine_amounts tf using(Ticket_Number)
join (
select Fine_Amount_ID, Current_Amount_Due 
from fine_amounts 
group by Fine_Amount_ID) f using(Fine_Amount_ID)
where f.Current_Amount_Due > 0
order by t.Ticket_Queue_Date;

-- 
create view queryfive as
select t.Ticket_number, t.Zip_code, t.Unit_description, n.Notice_Level from tickets t
join tickets_notices tn using(Ticket_number)
join notices n using(Notice_ID)
where n.Notice_Level = "VIOL";






