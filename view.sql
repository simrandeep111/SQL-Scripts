use school;
select * from emp;
create view sample as(
select * from emp where 
department in ("data analyst","data scientist") 
and city in ("noida","patna"));
select * from sample;
use covid_data;
select * from covid;
SELECT `who region`,MAX(active) AS March
FROM covid
WHERE MONTH(date) = 3
GROUP BY `who region`;
SELECT `who region`,MAX(active) AS April
FROM covid
WHERE MONTH(date) = 4
GROUP BY `who region`;

create view s2 as(
select t1.`who region`,march,april from
(SELECT `who region`,MAX(active) AS March
FROM covid
WHERE MONTH(date) = 3
GROUP BY `who region`)as t1
inner join
(SELECT `who region`,MAX(active) AS April
FROM covid
WHERE MONTH(date) = 4
GROUP BY `who region`)as t2
on t1.`who region`=t2.`who region`);
select * from s2;
drop view s2;