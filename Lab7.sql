                             -- Create a function that --
-- a. Increments given values by 1 and returns it.
create function inc(val numeric)
returns numeric as
$$
  begin
  return val+1;
end;
$$
language plpgsql;

select inc(30);

-- b. Returns sum of 2 numbers
create or replace function get_sum(a int, b int)
returns int as
    $$
    begin
        return a+b;
    end;
    $$
language plpgsql;

select get_sum(1,6);

-- c. Returns true or false if numbers are divisible by 2.
create or replace function divisible_2(val int)
returns boolean as
    $$
    declare
        mod2 int;
    begin
        mod2 = mod(val,2);
        return
        case
            when mod2 = 0 then true
            else false
            end;
    end;
    $$
language plpgsql;

select divisible_2(18);

-- d. Checks some password for validity
create or replace function validity(s varchar)
returns boolean as
    $$
    declare
         password varchar := 'Didar.2003' ;
    begin
        return
        case
            when s = password then true
            else false
            end;
    end;
    $$
language plpgsql;

select validity('asdf');

-- e. Returns two outputs, but has one input.
create or replace function squareofN(inout a int, out squareOf_a int)
as
    $$
    begin
        squareOf_a := a*a;
    end;
    $$
language plpgsql;

select * from squareofN(5);


                             -- 2. Create a trigger that:--


-- a. Return timestamp of the occured action within the database
create table exam(
    lesson varchar(50),
    time time
);

create or replace function TimeofAction()
returns trigger
as
    $$
    begin
        new.time = current_time;
        return new;
    end;
    $$
language plpgsql;

create or replace trigger calc_time
    before insert
    on exam
    for each row
    execute procedure TimeofAction();

insert into exam(lesson, time)
values ('Database' , default);

select * from exam;


--b. Computes the age of a person when persons’ date of birth is inserted.
create table teacher(
    name varchar,
    birthday timestamp,
    age text
              );

create or replace function countAge()
returns trigger
as
    $$
    declare
        age text;
    BEGIN
        select into age date_part('year', age('2003-01-23',new.birthday));
        new.birthday = age;
        return new;
    end;
    $$
language plpgsql;

create or replace trigger Cal_day
    before insert
    on teacher
    for each row
    execute procedure countAge();



-- c. Adds 12% tax on the price of the inserted item.
create table product(
    name varchar,
    price double precision
);

create or replace function total_price()
returns trigger as
    $$
    declare
        total numeric;
    BEGIN
         total = new.price * 1.12;
         new.price = total;
         return new;
    end;
    $$
language plpgsql;

create or replace trigger tax
   before insert
    on product
    for each row
   execute procedure  total_price();

-- d. Prevents deletion of any row from only one table.
create or replace function allow_to()
returns trigger
as
    $$
    begin
        if old.login = 'Dias' then
            raise exception 'You can not remove this row';
        end if;
    end;
    $$
language plpgsql;

create or replace trigger del_login
    before delete
    on account
    for each row
    execute procedure allow_to();

--e. Launches functions 1.d and 1.e.
--1.e
create or replace function root()
returns trigger
as
    $$
    declare
        bonus numeric;
    begin
        bonus = new.price - sqrt(new.price);
        new.price =  bonus ;
        return new;
    end;
    $$
language plpgsql;


create or replace trigger calc_Bonus
    before insert
    on product
    for each row
    execute procedure root();


--1.d

create table account
(
    login varchar(50),
    password varchar(50),
    checkk boolean
);
create or replace function check_password()
returns trigger
as
    $$
    declare
        pass varchar := 'database#1';
    BEGIN
       if new.password = pass then
           new.checkk = true;
        else new.checkk = false;
        end if;
       return new;
    end;
   $$
language plpgsql;

create or replace trigger NewAccount
    before insert
    on account
    for each row
    execute procedure check_password();


















