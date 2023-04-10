-- Необновляемое представление
CREATE or replace VIEW sellers AS
SELECT firstname,
       second_name,
       surname,
       date_of_birth,
       gender,
       address,
       phone_number,
       passport_code,
       position_at_work,
       rank
FROM employee
WHERE lower(position_at_work) LIKE '%продавец%';

SELECT *
FROM sellers;

update sellers
set rank = '1 разряд'
where firstname = 'Михаил'
returning *;

-- Необновляемое представление
create or replace view private_client as
select distinct on (firstname) firstname,
                               second_name,
                               surname
from client
--     where client_name =
;

drop view private_client;

select *
from private_client;

update private_client
set firstname = 'Артём'
where firstname = 'Артем'
returning *;

-- агрегирующее представление.
create or replace view prises_count as
select count(*)   as count,
       make_date(
               cast(date_part('year', date_of_sale) as int),
               cast(date_part('month', date_of_sale) as int),
               1) as date
from cheque
group by date_part('year', date_of_sale), date_part('month', date_of_sale)
order by date desc
;
drop view prises_count;
select *
from prises_count;
update private_client
set date = '2023-04-02'::date;



-- Представление, основанное на нескольких таблицах
CREATE or replace VIEW final_data_cheque AS
SELECT e.firstname || ' ' || e.second_name || ' ' || e.surname    as emploee_name,
       c3.firstname || ' ' || c3.second_name || ' ' || c3.surname as client_name,
       c3.phone_number                                            as contact_phone,
       c3.address                                                 as client_address,
       m.name                                                     as model,
       b.name                                                     as brand,
       c2.color_name                                              as color,
       c.year_of_release,
       cheque.date_of_sale
from cheque
         left join car c on c.id = cheque.car
         left join model m on m.id = c.model
         left join brand b on c.brand = b.id
         left join color c2 on c2.id = c.color
         left outer join employee e on e.id = cheque.employee
         left join client c3 on cheque.client = c3.id
;
drop view final_data_cheque;

select *
from final_data_cheque;

update final_data_cheque
set contact_phone = '+79995553535'
where client_name = 'Дмитрий Иваныч Макаров';

