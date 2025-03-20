create database marksheet;
use marksheet;
select * from mark;
select count(*),address from mark group by address;
select avg(marks), address from mark group by address; 
select count(*) as delhi from mark where address="delhi";
select avg(age)as girlage,address from mark where gender="girl"group by address order by girlage desc;
select max(marks), address from mark group by address;
select min(marks) as minmarks, address,gender from mark group by address,gender;  


DELIMITER //
create procedure max_marks(in A text)
begin
select max(marks),A from mark where address=A;
end //
DELIMITER ;
call max_marks("haryana");
select *,row_number() over(order by age desc)as rnk from mark;
select *,row_number() over(order by marks desc)as rnk from mark where address="bihar";
create view max_mark as(
select marks, address,students_name,rank() over(partition by address order by marks desc )as rnk from mark );
select marks as maxmarks,students_name,address from max_mark where rnk=1;