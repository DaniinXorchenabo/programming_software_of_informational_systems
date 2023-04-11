create or replace procedure add_colors(
    IN color_name_ text = 'Белый',
    IN other_color_name text = '#ffffff',
    inout is_insert bool = false
)
    LANGUAGE plpgsql
AS
$$
begin
    select (not exists(
            select *
            from color
            where color_name = color_name_
               or color_name = other_color_name
        ))
    into is_insert;
    if is_insert then
        insert into color (color_name) values (color_name_);
    end if;
end;
$$;

drop procedure add_colors;

CALL add_colors('Серый', '#666666', null);

create or replace procedure mod_color(
    IN color_name_ text = 'Белый',
    IN other_color_name text = '#ffffff',
    IN new_name text = 'Серый',
    inout is_update bool = false
)
    LANGUAGE plpgsql
AS
$$
declare
    is_exists_old_value bool;
    is_exists_new_value bool;
    is_duplicate_color  bool;
begin
    select exists(
                   select *
                   from color
                   where color_name = color_name_
                      or color_name = other_color_name
               )
    into is_exists_old_value;
    select exists(
                   select *
                   from color
                   where color_name = new_name
               )
    into is_exists_new_value;
    select exists(
                   select *
                   from color
                   where color_name = color_name_
                     and color_name = other_color_name
               )
    into is_duplicate_color;
    is_update = is_exists_old_value
        and not is_duplicate_color
        and not is_exists_new_value;
    if is_update then
        update color
        set color_name = new_name
        where color_name = color_name_
           or color_name = other_color_name;

    end if;
end;
$$;

drop procedure mod_color;

call mod_color('Серый', '#666666', 'Светло-серый');

create or replace procedure del_color(
    IN color_name_ text = 'Белый',
    IN other_color_name text = '#ffffff',
    inout is_delete bool = false
)
    LANGUAGE plpgsql
AS
$$
declare
begin
    select exists(
                   select *
                   from color
                   where color_name = color_name_
                      or color_name = other_color_name
               )
    into is_delete;
    if is_delete then
        delete
        from color
        where color_name = color_name_
           or color_name = other_color_name;
    end if;
end;
$$;


drop procedure del_color;
call del_color('Серый', '#666666', null);


create or replace procedure add_one_rank(
    in new_passport_code text
)
    LANGUAGE plpgsql
AS
$$
declare
begin
    update employee
    set rank = cast(
                       (CASE
                            WHEN cast(split_part(rank, ' ', 1) as int8) < 5
                                then cast(split_part(rank, ' ', 1) as int8) + 1
                            else cast(split_part(rank, ' ', 1) as int8)
                           end)
                   as text) || ' ' || split_part(rank, ' ', 2)
    where passport_code = new_passport_code;
end;
$$;

drop procedure add_one_rank;
call add_one_rank('7488357223');

create or replace procedure emp_stat(
    inout user_data float4
)
    LANGUAGE plpgsql
AS
$$
begin
select
cast( max(avg) as float4)
--     cast( array_agg(data) as anyarray)
    from (
    select
    AVG(sub.count)  as avg,
    sub.firstname || ' ' || sub.second_name || ' ' || sub.surname as name
--       ARRAY[
--           cast(AVG(sub.count)  as text)
--           sub.firstname || ' ' || sub.second_name || ' ' || sub.surname
--           ]
--           as data
from (select count(*)   as count,
             make_date(
                     cast(date_part('year', date_of_sale) as int),
                     cast(date_part('month', date_of_sale) as int),
                     1) as date,
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
HAVING
	AVG (sub.count) > 0
) as sub2 into user_data;
end;
$$;

drop procedure emp_stat;

call emp_stat(null);





