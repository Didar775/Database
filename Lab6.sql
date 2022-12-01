-- 1. Write a SQL query using Joins:

--a. combine each row of dealer table with each row of client table
select * from dealer cross join client;

--b. find all dealers along with client name, city, grade, sell number, date, and amount
select c.dealer_id, client_id, name, city,priority, date ,amount  from client c inner join sell s
         on c.dealer_id = s.dealer_id and s.client_id = c.id;

--c. find the dealer and client who belongs to same city
select * from dealer d  inner join client c  on d.location = c.city;

-- d. find sell id, amount, client name, city those sells where sell amount exists between
-- 100 and 500

select s.id , amount, name, city from sell s inner join client c
on  s.client_id = c.id
where s.amount between 100 and  500  ;

-- e. find dealers who works either for one or more client or not yet join under any of
-- the clients
select * from client c right join dealer d on d.id = c.dealer_id;


--f. find the dealers and the clients he service, return client name, city, dealer name,
--commission.

select c.name, c.city, d.name, d.charge from  dealer d inner join client c on d.id = c.dealer_id;


--find client name, client city, dealer, commission those dealers who received
-- a commission from the sell more than 12%

select * from   client c join dealer d on c.dealer_id = d.id
where d.charge > 0.12;

-- h. make a report with client name, city, sell id, sell date, sell amount, dealer name
-- and commission to find that either any of the existing clients haven’t made a
-- purchase(sell) or made one or more purchase(sell) by their dealer or by own.
select cs.name, cs.city, s.id, s.date, s.amount, cs.charge from
(client c inner join dealer d on c.dealer_id = d.id ) cs
left join sell s on s.client_id = client_id and cs.dealer_id = s.dealer_id;


--i. find dealers who either work for one or more clients. The client may have made,
--either one or more purchases, or purchase amount above 2000 and must have a
--grade, or he may not have made any purchase to the associated dealer. Print
--client name, client grade, dealer name, sell id, sell amount

select cs.name, cs.priority, d.name, cs.id, cs.amount from
dealer d left join (client c left join  sell s on s.amount > 2000 and priority is not  null) cs
on d.id = cs.dealer_id;


 -- 2. Create following views:--

 -- a. count the number of unique clients, compute average and total purchase
-- amount of client orders by each date.
create view  unique_clients as
    select count (c.id), avg(amount) , sum(amount) , date
from sell inner join client c on c.id = sell.client_id
group by (date);

select * from unique_clients;


--b. find top 5 dates with the greatest total sell amount
create view top_5 as
    select sum(amount), date
    from sell
    group by(date)
     order by sum(amount) desc
     limit 5;

select * from top_5;


--c. count the number of sales, compute average and total amount of all
--sales of each dealer
create view dealer_n as
    select count(id) , avg(amount), sum(amount), dealer_id
from sell
group by dealer_id;

select * from dealer_n;

-- d. compute how much all dealers earned from charge(total sell amount *
-- charge) in each location

create view earned as
    select sum(amount) * dealer.charge, location
    from (dealer inner join sell s on dealer.id = s.dealer_id) d,
    group by (location)

-- e. compute number of sales, average and total amount of all sales dealers
-- made in each location

create view sales as
    select count(*), avg(amount), sum(amount) , location
    from sell inner join dealer d on sell.dealer_id = d.id
    group by (location);

select * from sales;

--f. compute number of sales, average and total amount of expenses in
--each city clients made.
create view clients as
    select count(*) , avg(amount), sum(amount), city
   from sell inner join client c on c.id = sell.client_id
   group by(city);

select * from clients;

--g. find cities where total expenses more than total amount of sales in
--locations

























