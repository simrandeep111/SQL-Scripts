use covid_data;
select * from covid;
create view co19 as(
select country,sum(confirmed)as conf,
sum(deaths) as death,sum(active) as active,sum(recovered) as reco
from covid group by country);
select * from co19;
select country from co19 order by conf desc limit 1;
select * from co19 where active >(select avg(active) from co19);

DELIMITER //

create procedure pks()
begin
select * from covid;
end //
DELIMITER ;

call pks;
DELIMITER //
create procedure pks2(IN region varchar(25), OUT coun INT)
begin
select count(distinct country) from covid where `who region`=region;
end //
DELIMITER ;
drop procedure pks2;
call pks2('europe',@country);

select count(distinct country) from covid where `who region`='europe';