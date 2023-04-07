CREATE OR REPLACE FUNCTION random_between(low INT, high INT)
    RETURNS float4 AS
$$
BEGIN
    RETURN cast((random() * (high - low + 1) + low) as float4) ;
END;
$$ language 'plpgsql' STRICT;

CREATE OR REPLACE FUNCTION random_string(len_ int, dataset text)
    returns text as
$$
BEGIN
    return array_to_string(array(select substr(dataset, ((random() * (char_length(dataset) - 1) + 1)::integer), 1)
                                 from generate_series(1, len_)), '');

end;
$$ language 'plpgsql' STRICT;

CREATE OR REPLACE FUNCTION random_date(from_ timestamp without time zone, to_ timestamp without time zone)
    returns TIMESTAMP as
$$
BEGIN
    return cast(from_ + random_between(0, 0) * (to_ - from_) as TIMESTAMP);
end;
$$ language 'plpgsql' STRICT;

CREATE OR REPLACE FUNCTION random_address(street text)
    returns text as
$$
BEGIN
    return 'Пензенская обл., г. Пенза, ' || street || ' ул., д. '
               || cast(cast(random() * 200 + 1 as int) as text) || ', кв. '
        || cast(cast(random() * 200 + 1 as int) as text);

end ;
$$ language 'plpgsql' STRICT;

CREATE OR REPLACE FUNCTION random_phone()
    returns text as
$$
BEGIN
    return '+79'
        || random_string(9, '0123456789');

end ;
$$ language 'plpgsql' STRICT;


CREATE OR REPLACE FUNCTION customize_random()
    returns float4 as
$$
BEGIN
    return random();
end;
$$ language 'plpgsql' STRICT;


INSERT INTO brand (name)
VALUES ('Волга'),
       ('BMW'),
       ('Ford'),
       ('Honda'),
       ('Hyundai'),
       ('Kia'),
       ('Mercedes-Benz'),
       ('Mitsubishi'),
       ('Nissan'),
       ('Renault'),
       ('Skoda'),
       ('Toyota'),
       ('Volkswagen'),
       ('Acura'),
       ('Audi');
INSERT INTO color (color_name)
VALUES ('#ff00ff'),
       ('Чёрный'),
       ('Белый'),
       ('Тёмно-красный'),
       ('Зелёный'),
       ('Синий'),
       ('Голубой'),
       ('Красный'),
       ('Фиолетовый'),
       ('Хаки');
INSERT INTO model (name, engine_capacity, max_speed, count_of_doors, number_of_seats)
VALUES ('Maruti-Suzuki', 0.9, 180.0, 4, 5)
     , ('Xiaopeng', 0.9, 180.0, 4, 5)
     , ('Geely', 0.9, 180.0, 4, 5)
     , ('ZSD', 0.9, 180.0, 4, 5)
     , ('КаВЗ', 0.9, 180.0, 4, 5)
     , ('Pierce-Arrow', 0.9, 180.0, 4, 5)
     , ('Westfalia', 0.9, 180.0, 4, 5)
     , ('BJEV', 0.9, 180.0, 4, 5)
     , ('Diatto', 0.9, 180.0, 4, 5)
     , ('MOST', 0.9, 180.0, 4, 5);
INSERT INTO car
SELECT uuid_generate_v4()                                        as id,
       b_.id                                                     as brand,
       m_.id                                                     as model,
       t_.name                                                   as transmission,
       random_string(16, '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ') as registration_number,
       random_string(10, '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ') as trailer_number,
       eng_.engine_model                                         as engine_model,
       random_string(2, '0123456789')
           || random_string(2, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')
           || random_string(6, '0123456789')                     as number_technical_passport,
       random_date('2000-01-01'::timestamp, now()::timestamp)    as year_of_release,
       c_.id                                                     as color
FROM generate_series(1, 1)
         LEFT JOIN (SELECT id
                    FROM brand
                    order by random()) as b_ ON true
         LEFT JOIN (SELECT id
                    FROM model
                    order by random()) as m_ ON true
         LEFT JOIN (SELECT id
                    FROM color
                    order by random()) as c_ ON true
         LEFT JOIN (values ('механика'),
                           ('автомат'),
                           ('полуавтомат')) t_ (name) on true
         LEFT JOIN (values ('M102'),
                           ('M111'),
                           ('M166'),
                           ('M254'),
                           ('M260'),
                           ('M264'),
                           ('M266'),
                           ('M270'),
                           ('M271'),
                           ('M274'),
                           ('M282'),
                           ('EA113'),
                           ('CMBA'),
                           ('CXSA'),
                           ('CZCA'),
                           ('CZDA'),
                           ('CZEA'),
                           ('TFSI'),
                           ('DADA'),
                           ('AEH'),
                           ('AHL'),
                           ('AKL'),
                           ('ALZ'),
                           ('ANA'),
                           ('APF'),
                           ('ARM'),
                           ('AVU'),
                           ('BFQ'),
                           ('BGU'),
                           ('BSE'),
                           ('BSF'),
                           ('ВАЗ-11182'),
                           ('ВАЗ-11183'),
                           ('ВАЗ-11186'),
                           ('ВАЗ-11189'),
                           ('ВАЗ-11194'),
                           ('ВАЗ-21114'),
                           ('ВАЗ-21116'),
                           ('ВАЗ-21124'),
                           ('ВАЗ-21126'),
                           ('ВАЗ-21127'),
                           ('ВАЗ-21128'),
                           ('ВАЗ-21129')) eng_ (engine_model) ON true
order by random()
LIMIT 15;
INSERT INTO client
SELECT uuid_generate_v4()           as id,
       names_.name                  as firstname,
       sec_.name                    as second_name,
       surname_.name                as surname,
       null                         as client_name,
       random_address(street_.name) as address,
       random_phone()               as phone_number
FROM generate_series(1, 1)
         LEFT JOIN (values ('Александр'),
                           ('Дмитрий'),
                           ('Максим'),
                           ('Сергей'),
                           ('Андрей'),
                           ('Алексей'),
                           ('Артём'),
                           ('Илья'),
                           ('Кирилл'),
                           ('Михаил'),
                           ('Никита'),
                           ('Матвей'),
                           ('Роман'),
                           ('Егор'),
                           ('Арсений'),
                           ('Иван'),
                           ('Денис'),
                           ('Евгений'),
                           ('Тимофей'),
                           ('Владислав'),
                           ('Игорь'),
                           ('Владимир'),
                           ('Павел'),
                           ('Руслан'),
                           ('Марк'),
                           ('Константин'),
                           ('Тимур'),
                           ('Олег'),
                           ('Ярослав'),
                           ('Антон'),
                           ('Николай'),
                           ('Данил')) names_ (name) on true
         LEFT JOIN (values ('Александрович'),
                           ('Алексеевич'),
                           ('Анатольевич'),
                           ('Андреевич'),
                           ('Антонович'),
                           ('Аркадьевич'),
                           ('Артемович'),
                           ('Бедросович'),
                           ('Богданович'),
                           ('Борисович'),
                           ('Валентинович'),
                           ('Валерьевич'),
                           ('Васильевич'),
                           ('Викторович'),
                           ('Витальевич'),
                           ('Владимирович'),
                           ('Владиславович'),
                           ('Вольфович'),
                           ('Вячеславович'),
                           ('Геннадиевич'),
                           ('Георгиевич'),
                           ('Григорьевич'),
                           ('Данилович'),
                           ('Денисович'),
                           ('Дмитриевич'),
                           ('Евгеньевич'),
                           ('Егорович'),
                           ('Ефимович'),
                           ('Иванович'),
                           ('Иваныч'),
                           ('Игнатьевич'),
                           ('Игоревич'),
                           ('Ильич'),
                           ('Иосифович'),
                           ('Исаакович'),
                           ('Кириллович'),
                           ('Константинович'),
                           ('Леонидович'),
                           ('Львович'),
                           ('Максимович'),
                           ('Матвеевич'),
                           ('Михайлович'),
                           ('Николаевич'),
                           ('Олегович'),
                           ('Павлович'),
                           ('Палыч'),
                           ('Петрович'),
                           ('Платонович'),
                           ('Робертович'),
                           ('Романович'),
                           ('Саныч'),
                           ('Северинович'),
                           ('Семенович'),
                           ('Сергеевич'),
                           ('Станиславович'),
                           ('Степанович'),
                           ('Тарасович'),
                           ('Тимофеевич'),
                           ('Федорович'),
                           ('Феликсович'),
                           ('Филиппович'),
                           ('Эдуардович'),
                           ('Юрьевич'),
                           ('Яковлевич'),
                           ('Ярославович')) surname_ (name) on true
         LEFT JOIN (values ('Иванов'),
                           ('Смирнов'),
                           ('Кузнецов'),
                           ('Попов'),
                           ('Васильев'),
                           ('Петров'),
                           ('Соколов'),
                           ('Михайлов'),
                           ('Новиков'),
                           ('Федоров'),
                           ('Морозов'),
                           ('Волков'),
                           ('Алексеев'),
                           ('Лебедев'),
                           ('Семенов'),
                           ('Егоров'),
                           ('Павлов'),
                           ('Козлов'),
                           ('Степанов'),
                           ('Николаев'),
                           ('Орлов'),
                           ('Андреев'),
                           ('Макаров'),
                           ('Никитин'),
                           ('Захаров'),
                           ('Зайцев'),
                           ('Соловьев'),
                           ('Борисов'),
                           ('Яковлев'),
                           ('Григорьев'),
                           ('Романов'),
                           ('Воробьев'),
                           ('Сергеев'),
                           ('Кузьмин'),
                           ('Фролов'),
                           ('Александров'),
                           ('Дмитриев'),
                           ('Королев'),
                           ('Гусев'),
                           ('Киселев')) sec_ (name) on true
         LEFT JOIN (values ('Центральная'),
                           ('Молодежная'),
                           ('Школьная'),
                           ('Лесная'),
                           ('Советская'),
                           ('Новая'),
                           ('Садовая'),
                           ('Набережная'),
                           ('Заречная'),
                           ('Зеленая'),
                           ('Мира'),
                           ('Ленина'),
                           ('Полевая'),
                           ('Луговая'),
                           ('Октябрьская'),
                           ('Комсомольская'),
                           ('Гагарина'),
                           ('Первомайская'),
                           ('Северная'),
                           ('Солнечная'),
                           ('Степная'),
                           ('Южная'),
                           ('Береговая'),
                           ('Кирова'),
                           ('Пионерская'),
                           ('Юбилейная'),
                           ('Речная'),
                           ('Нагорная'),
                           ('Восточная')) street_ (name) on true
order by random()
LIMIT 15;
INSERT INTO employee
SELECT uuid_generate_v4()                                            as id,
       firstname,
       second_name,
       surname,
       random_date('1940-01-01'::timestamp, '2005-01-01'::timestamp) as date_of_birth,
       gender,
       random_address(street)                                        as address,
       random_phone()                                                as phone_number,
       random_string(10, '0123456789')                               as passport_code,
       position_at_work,
       random_string(1, '12345') || ' разряд'                        as rank
from (SELECT names_.name   as firstname,
             sec_.name     as second_name,
             surname_.name as surname,
             gender_.name  as gender,
             street_.name  as street,
             pos_.name     as position_at_work
      FROM generate_series(1, 1)
               LEFT JOIN (values ('Александр'),
                                 ('Дмитрий'),
                                 ('Максим'),
                                 ('Сергей'),
                                 ('Андрей'),
                                 ('Алексей'),
                                 ('Артём'),
                                 ('Илья'),
                                 ('Кирилл'),
                                 ('Михаил'),
                                 ('Никита'),
                                 ('Матвей'),
                                 ('Роман'),
                                 ('Егор'),
                                 ('Арсений'),
                                 ('Иван'),
                                 ('Денис'),
                                 ('Евгений'),
                                 ('Тимофей'),
                                 ('Владислав'),
                                 ('Игорь'),
                                 ('Владимир'),
                                 ('Павел'),
                                 ('Руслан'),
                                 ('Марк'),
                                 ('Константин'),
                                 ('Тимур'),
                                 ('Олег'),
                                 ('Ярослав'),
                                 ('Антон'),
                                 ('Николай'),
                                 ('Данил')) names_ (name) on true
               LEFT JOIN (values ('Александрович'),
                                 ('Алексеевич'),
                                 ('Анатольевич'),
                                 ('Андреевич'),
                                 ('Антонович'),
                                 ('Аркадьевич'),
                                 ('Артемович'),
                                 ('Бедросович'),
                                 ('Богданович'),
                                 ('Борисович'),
                                 ('Валентинович'),
                                 ('Валерьевич'),
                                 ('Васильевич'),
                                 ('Викторович'),
                                 ('Витальевич'),
                                 ('Владимирович'),
                                 ('Владиславович'),
                                 ('Вольфович'),
                                 ('Вячеславович'),
                                 ('Геннадиевич'),
                                 ('Георгиевич'),
                                 ('Григорьевич'),
                                 ('Данилович'),
                                 ('Денисович'),
                                 ('Дмитриевич'),
                                 ('Евгеньевич'),
                                 ('Егорович'),
                                 ('Ефимович'),
                                 ('Иванович'),
                                 ('Иваныч'),
                                 ('Игнатьевич'),
                                 ('Игоревич'),
                                 ('Ильич'),
                                 ('Иосифович'),
                                 ('Исаакович'),
                                 ('Кириллович'),
                                 ('Константинович'),
                                 ('Леонидович'),
                                 ('Львович'),
                                 ('Максимович'),
                                 ('Матвеевич'),
                                 ('Михайлович'),
                                 ('Николаевич'),
                                 ('Олегович'),
                                 ('Павлович'),
                                 ('Палыч'),
                                 ('Петрович'),
                                 ('Платонович'),
                                 ('Робертович'),
                                 ('Романович'),
                                 ('Саныч'),
                                 ('Северинович'),
                                 ('Семенович'),
                                 ('Сергеевич'),
                                 ('Станиславович'),
                                 ('Степанович'),
                                 ('Тарасович'),
                                 ('Тимофеевич'),
                                 ('Федорович'),
                                 ('Феликсович'),
                                 ('Филиппович'),
                                 ('Эдуардович'),
                                 ('Юрьевич'),
                                 ('Яковлевич'),
                                 ('Ярославович')) surname_ (name) on true
               LEFT JOIN (values ('Иванов'),
                                 ('Смирнов'),
                                 ('Кузнецов'),
                                 ('Попов'),
                                 ('Васильев'),
                                 ('Петров'),
                                 ('Соколов'),
                                 ('Михайлов'),
                                 ('Новиков'),
                                 ('Федоров'),
                                 ('Морозов'),
                                 ('Волков'),
                                 ('Алексеев'),
                                 ('Лебедев'),
                                 ('Семенов'),
                                 ('Егоров'),
                                 ('Павлов'),
                                 ('Козлов'),
                                 ('Степанов'),
                                 ('Николаев'),
                                 ('Орлов'),
                                 ('Андреев'),
                                 ('Макаров'),
                                 ('Никитин'),
                                 ('Захаров'),
                                 ('Зайцев'),
                                 ('Соловьев'),
                                 ('Борисов'),
                                 ('Яковлев'),
                                 ('Григорьев'),
                                 ('Романов'),
                                 ('Воробьев'),
                                 ('Сергеев'),
                                 ('Кузьмин'),
                                 ('Фролов'),
                                 ('Александров'),
                                 ('Дмитриев'),
                                 ('Королев'),
                                 ('Гусев'),
                                 ('Киселев')) sec_ (name) on true
               LEFT JOIN (values ('Центральная'),
                                 ('Молодежная'),
                                 ('Школьная'),
                                 ('Лесная'),
                                 ('Советская'),
                                 ('Новая'),
                                 ('Садовая'),
                                 ('Набережная'),
                                 ('Заречная'),
                                 ('Зеленая'),
                                 ('Мира'),
                                 ('Ленина'),
                                 ('Полевая'),
                                 ('Луговая'),
                                 ('Октябрьская'),
                                 ('Комсомольская'),
                                 ('Гагарина'),
                                 ('Первомайская'),
                                 ('Северная'),
                                 ('Солнечная'),
                                 ('Степная'),
                                 ('Южная'),
                                 ('Береговая'),
                                 ('Кирова'),
                                 ('Пионерская'),
                                 ('Юбилейная'),
                                 ('Речная'),
                                 ('Нагорная'),
                                 ('Восточная')) street_ (name) on true
               LEFT JOIN (values ('м')
--                            , ('ж')
      ) gender_ (name) on true
               LEFT JOIN (values ('Продовец'),
                                 ('Консультант'),
                                 ('Старший продовец'),
                                 ('Младший продовец'),
                                 ('Старший кассир'),
                                 ('Младший кассир'),
                                 ('Кассир')) pos_ (name) on true
      order by random()
      LIMIT 15) as sq_;

INSERT INTO cheque
SELECT uuid_generate_v4()                                     as id,
       emp_.id                                                as employee,
       cl_.id                                                 as client,
       random_date('2023-01-01'::timestamp, now()::timestamp) as date_of_sale,
       customize_random() > 0.5                               as payment_mark,
       car_.id                                                as car
FROM generate_series(1, 15)
         LEFT JOIN (SELECT id
                    FROM employee
                    order by random()) as emp_ ON true
         LEFT JOIN (SELECT id
                    FROM client
                    order by random()) as cl_ ON true
         LEFT JOIN (SELECT id
                    FROM car
                    order by random()) as car_ ON true
order by random()
LIMIT 15;



SELECT char_length('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789');
SELECT array_to_string(
               array(select substr('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', ((random() * (36 - 1) + 1)::integer), 1)
                     from generate_series(1, 10)), '');
SELECT cast(timestamp '1950-01-01' +
            random_between(0, 1) * (timestamp '2049-12-31' -
                                    timestamp '1950-01-01') as DATE)
FROM generate_series(1, 10);


-- Популярные марки авто Audi BMW  Honda Hyundai Kia Lada (ВАЗ) Mazda Mercedes-Benz Mitsubishi Nissan Renault Skoda Toyota Volkswagen Японские марки авто Acura Daihatsu Datsun Honda Infiniti Isuzu Lexus Mazda Mitsubishi Nissan Scion Subaru Suzuki