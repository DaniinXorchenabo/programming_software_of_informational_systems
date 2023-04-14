-- Возвращает скаляр
create or replace function get_max_engine_capacity_for_client(
    first_name text,
    second_name_ text,
    sur_name text
)
    returns float4
    LANGUAGE plpgsql as
$$
declare
    res float4;
BEGIN
    select max(m.engine_capacity)
    into res
    from client as cl_
             inner join cheque c on cl_.id = c.client
             left join car c2 on c.car = c2.id
             left join model m on m.id = c2.model
    where cl_.firstname = first_name
      and cl_.second_name = second_name_
      and cl_.surname = sur_name;
    return cast(res as float4);
end;
$$;

select get_max_engine_capacity_for_client('Кирилл'::text, 'Романович'::text, 'Захаров'::text);


-- Функция, возвращающая таблицу
CREATE or replace FUNCTION only_named_colors() RETURNS SETOF color AS
$$
SELECT *
FROM color
WHERE color_name not like '#%';
$$ LANGUAGE SQL;

drop function only_named_colors;

select *
from only_named_colors();


-- Многооператорная функция, возвращающая таблицу
CREATE or replace FUNCTION employee_stats()
    RETURNS table
            (
                stat_data   float4,
                firstname   text,
                second_name text,
                surname     text
            )
AS
$$
select cast(round(AVG(sub.count), 2) as float4) as stat_data,
       sub.firstname,
       sub.second_name,
       sub.surname

from (select count(*) as count,
             e.firstname,
             e.second_name,
             e.surname
      from cheque
               left join employee e on e.id = cheque.employee
      group by date_part('year', date_of_sale),
               date_part('month', date_of_sale),
               e.id) as sub
group by sub.firstname,
         sub.second_name,
         sub.surname
HAVING AVG(sub.count) > 0
order by stat_data desc
$$ LANGUAGE SQL;

drop function employee_stats;

select * from employee_stats();

