--1	Вывести машины, дата выпуска которых попадает в диапазон от 01.01.2010 до 01.01.2020.
SELECT b.name,
       m.name,
       year_of_release,
       c.color_name,
       transmission,
       registration_number,
       trailer_number,
       engine_model
from car
         left outer join color c on c.id = car.color
         left join model m on m.id = car.model
         left outer join brand b on b.id = car.brand
where year_of_release BETWEEN '2010-01-01'::date AND '2020-01-01'::date;

-- 2.	Вывести максимальную скорость продаваемых машин
SELECT max(max_speed)
from model;

--1.	Определить ФИО сотрудника, продавшего самый быстрый (из проданных) автомобиль. (join)
SELECT distinct m.max_speed, employee.firstname, employee.surname, employee.second_name
FROM employee
         RIGHT join cheque ch_ on employee.id = ch_.employee
         LEFT OUTER JOIN car car_ on car_.id = ch_.car
         INNER JOIN model m on m.id = car_.model
WHERE m.max_speed = (SELECT max(max_speed)
                     from model
                              right join car car_2 on model.id = car_2.model
                              right join cheque c on car_2.id = c.car);

--2.	Определить самые популярные (по количеству покупок) автомобили (group by)
select count(ch_) as buy_count, b.name, m.name
from car
         right outer join cheque ch_ on car.id = ch_.car
         left join car c on c.id = ch_.car
         left join brand b on b.id = c.brand
         left join model m on c.model = m.id
group by ch_.car, b.name, m.name
order by buy_count DESC;

-- 3.	Вывести ФИО сотрудника, продающего автомобили только с объёмом двигателя больше 1. (ANY)
select firstname, surname, second_name, date_of_birth
from employee
where employee.id = ANY (select sub.id
                         from (select employee.id            as id,
                                      min(m.engine_capacity) as min_engine_capacity
                               from employee
                                        right outer join cheque c on employee.id = c.employee
                                        inner join car c2 on c2.id = c.car
                                        inner join model m on m.id = c2.model
                               group by employee.id) AS sub
                         where sub.min_engine_capacity > 1);

-- 4.	Вывести модель автомобиля, который был куплен человеком, чьё имя начинающейся на букву «Е». (маска LIKE ‘Е%’)
SELECT array_agg(c2.firstname || ' ' || c2.surname), b.name, m.name
from car
         right join cheque c on car.id = c.car
         left join client c2 on c2.id = c.client
         left outer join brand b on b.id = car.brand
         left outer join model m on m.id = car.model
where c2.firstname LIKE 'Е%'
group by car.id, b.name, m.name;
--
-- select *
-- from (select cl1_.id as id,
--              cl1_.firstname,
--              cl1_.surname,
--              cl2_.firstname,
--              cl2_.surname
--       from client as cl1_
--                inner join client cl2_ on cl2_.firstname = cl1_.firstname
--           and cl2_.id != cl1_.id) as sub_
-- ;
--
-- select  _cl1.id as id, _cl1.firstname as firstname
--       from client as _cl1
--                inner join cheque ch1_ on ch1_.client = _cl1.id;

--5.	Вывести автомобили, которые были куплены тёзками (одинаковые имена). (select в select)
select distinct on (c.id) b.name,
                          m.name,
                          c.year_of_release,
                          c.transmission,
                          c.registration_number,
                          cl1__.firstname,
                          cl1__.second_name,
                          cl1__.surname,
                          cl2__.firstname,
                          cl2__.second_name,
                          cl2__.surname
from (select distinct *,
                      cl1_.id as cl1_id,
                      cl2_.id as cl2_id
      from (select _cl1.id        as id,
                   _cl1.firstname as firstname
            from client as _cl1
                     inner join cheque ch1_ on ch1_.client = _cl1.id) as cl1_
               inner join
           (select _cl2.id        as id,
                   _cl2.firstname as firstname
            from client as _cl2
                     inner join cheque ch2_ on ch2_.client = _cl2.id) cl2_
           on cl2_.firstname = cl1_.firstname and cl2_.id != cl1_.id) as sub_
         inner join cheque ch_ on ch_.client = sub_.cl1_id
         left join car c on c.id = ch_.car
         left join brand b on b.id = c.brand
         left outer join model m on m.id = c.model
         left outer join client cl1__ on sub_.cl1_id = cl1__.id
         left outer join client cl2__ on sub_.cl2_id = cl2__.id
;

--6.	Подсчитать количество продаж сотрудников старше 50 лет (агрегация)
SELECT count(cheque.employee), e.firstname, e.second_name, e.surname, e.date_of_birth
from cheque
         right join employee e on e.id = cheque.employee
where date_part('year', (now())) - date_part('year', (e.date_of_birth)) > 50
group by e.id;

-- 7.	Вывести покупателей автомобилей, которые были произведены раньше 2005 года. (дата)
SELECT
--     c.year_of_release,
firstname,
second_name,
surname
from client
-- right join cheque c3 on client.id = c3.client
-- left join car c on c.id = c3.car
where client.id = any (select c2.id
                       from car
                                right outer join cheque c on car.id = c.car
                                left outer join client c2 on c2.id = c.client
                       where car.year_of_release < '2005-01-01');

-- 8.	Вывести автомобиль, у которого самое длинное название цвета (агрегация).
select c.color_name, m.name, b.name, car.transmission, car.year_of_release
from car
         left outer join color c on c.id = car.color
         left outer join brand b on b.id = car.brand
         left outer join model m on c.id = m.id
where char_length(c.color_name) = (select max(char_length(col_.color_name))
                                   from color as col_
                                            right join public.car c2 on col_.id = c2.color);

-------------------
SELECT max(max_speed)
from model
         right join car car_2 on model.id = car_2.model
         right join cheque c on car_2.id = c.car