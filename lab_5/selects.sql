SELECT *
from car
where year_of_release BETWEEN '2010-01-01'::date AND '2020-01-01'::date;

SELECT max(max_speed)
from model;

SELECT distinct m.max_speed, employee.firstname, employee.surname, employee.second_name, employee.id
FROM employee
         RIGHT join cheque ch_ on employee.id = ch_.employee
         LEFT OUTER JOIN car car_ on car_.id = ch_.car
         INNER JOIN model m on m.id = car_.model
WHERE m.max_speed = (SELECT max(max_speed)
                     from model
                              right join car car_2 on model.id = car_2.model
                              right join cheque c on car_2.id = c.car);

select count(ch_) as ch_count, ch_.car
from car
         right outer join cheque ch_ on car.id = ch_.car
group by ch_.car
order by ch_count DESC;

select *
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

SELECT array_agg (c2.firstname || ' ' || c2.surname), car.id
from car
right join cheque c on car.id = c.car
left join client c2 on c2.id = c.client
where c2.firstname LIKE 'М%'
group by car.id;

SELECT count(cheque.employee),e.id, e.date_of_birth
from cheque
right join employee e on e.id = cheque.employee
where  date_part('year', ( now())) - date_part('year', ( e.date_of_birth)) > 50
group by e.id;


SELECT
--     c.year_of_release,
    *
from client
-- right join cheque c3 on client.id = c3.client
-- left join car c on c.id = c3.car
where client.id = any(
    select c2.id
    from car
    right outer join cheque c on car.id = c.car
    left outer join client c2 on c2.id = c.client
    where car.year_of_release < '2005-01-01'::date
    );


select  c.color_name, *
from car
left outer join color c on c.id = car.color
where char_length(c.color_name) = (
select max(char_length(col_.color_name))
from color as col_
right join public.car c2 on col_.id = c2.color
);

-------------------
SELECT max(max_speed)
from model
         right join car car_2 on model.id = car_2.model
         right join cheque c on car_2.id = c.car