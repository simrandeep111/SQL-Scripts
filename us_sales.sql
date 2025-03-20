create database us_sales;
use us_sales;
select * from sales;
select * from sales where product_type in('coffee','tea','herbal Tea');
select state from sales where (state like 'a%' or state like 'i%'or state like 'e%' or state like 'o%' ) and
(state like '%t' or state like '%o'or state like '%a' or state like '%n' );
 select * from sales where state='Connecticut' and product_type in('coffee','tea');
 
 select concat_ws('-',product,sales,state) as combine from sales;
 select concat(state,'(',total_expenses,')') as total_expenses from sales; 
 
 create view T1 as(
 select state, length(state) as len from sales group by state);
 select * from T1;
 select len,state from T1 where len=(select max(len) from T1 order by state desc)limit 1;
select len,state from T1 where len=(select min(len) from T1 order by state desc)limit 1;
select state,max(cogs)-min(cogs) as diff from sales group by state;
create view T2 as(
select length(state) as len,state,market from sales group by state,market order by state);

select * from T2 where len=(select min(len) from T2);
select avg(cogs),avg(total_expenses),state from sales where 
cogs>(select avg(cogs) from sales) and total_expenses <=(select avg(total_expenses) from sales)group by state;

select * from sales;
select sum(sales),monthname(date) from sales where `type`='regular' group by monthname(date);
select max(expected_sales) as max_sale,market from sales group by market order by max_sale desc limit 1;
select sum(margin-profit) as diff,market,product_type from sales group by market,product_type;
select distinct date,dayname(date),monthname(date) from sales order by (select(date)),(select monthname(date));
select sum(profit),sum(sales),sum(total_expenses),state from sales group by state;
select si_no ,`type`, state from sales where `type`='regular' and state ='new york' and si_no%2 <> 0 order by expected_margin desc;
create view T3 as(
select profit,state,market from sales where state='Washington' and market in('east','west','north'));

select * from T3 where profit=(select max(profit) from T3) or profit=(select min(profit) from T3);

create view T4 as(
select  Profit, Margin, Sales, COGS, Total_Expenses, Marketing, Expected_Profit, Expected_COGS, Expected_Margin, Expected_Sales from sales 

where Profit <0 or Margin<0 or Sales<0 or COGS<0 or Total_Expenses<0 or Marketing<0 or Expected_Profit<0 or Expected_COGS<0  or Expected_Margin<0 or Expected_Sales<0);
SET sql_safe_updates = 0;
update T4
set profit=abs(profit),
margin=abs(margin),
Sales=abs(sales),
Expected_Profit=abs(Expected_Profit),
Expected_Margin=abs(Expected_Margin)
where Profit <0 or Margin<0 or Sales<0 or Expected_Profit<0 or Expected_Margin<0;
select * from sales;
select sum(sales)as total_sales,product from sales group by product order by total_sales desc limit 5;
select count(*),state from sales group by state;
SELECT sum(sales) AS total_sales_amount
FROM sales;
SELECT sum(sales),state AS total_sales_amount
FROM sales group by state;
create view T5 as(
select count(product) as quan,product from sales group by product);
drop view T5;
select max(quan) from T5;
select min(quan) from T5;
select sum(sales) from sales where date >  2011-05-10 ;
select *,(profit/sales)*100 as profit_margin from sales where (profit/sales)*100 >50; 




