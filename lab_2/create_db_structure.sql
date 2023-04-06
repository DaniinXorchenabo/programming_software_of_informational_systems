-- create type car_type_enum as enum ('passenger','truck');
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

SELECT uuid_generate_v4();

CREATE TABLE "brand"
(
    "id"   UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),
    "name" TEXT UNIQUE NOT NULL
        CONSTRAINT brand__name CHECK (brand.name SIMILAR TO '[- A-Za-zА-ЯЁёа-я0-9]{1,50}')
);

CREATE TABLE "client"
(
    "id"           UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),
    "firstname"    TEXT NOT NULL
        CONSTRAINT client__firstname CHECK (client.firstname SIMILAR TO '[А-ЯЁ][а-яё]{1,49}'),
    "surname"      TEXT NOT NULL
        CONSTRAINT client__surname CHECK (client.surname SIMILAR TO '[А-ЯЁ][а-яё]{1,49}'),
    "second_name"  TEXT
        CONSTRAINT client__second_name CHECK (client.second_name SIMILAR TO '[А-ЯЁ][а-яё]{4,49}'),
    "client_name"  TEXT NULL
        CONSTRAINT client__client_name CHECK (client.client_name SIMILAR TO '[- 0-9A-Za-zА-ЯЁёа-я]{2,50}'),
    "address"      TEXT
        CONSTRAINT client__address CHECK (client.address SIMILAR TO '[- А-ЯЁёа-я0-9«»"".,]{10,150}'),
    "phone_number" TEXT
        CONSTRAINT client__phone_number CHECK (client.phone_number SIMILAR TO '\+[0-9]{9,16}')
);

CREATE TABLE "color"
(
    "id"         UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),
    "color_name" TEXT UNIQUE NOT NULL
        CONSTRAINT color__color_name CHECK (color.color_name SIMILAR TO '([А-ЯЁ][-а-яё]{3,49})|(#[0-9a-f]{6})')
);

CREATE TABLE "employee"
(
    "id"               UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),
    "firstname"        TEXT NOT NULL
        CONSTRAINT employee__firstname CHECK (employee.firstname SIMILAR TO '[А-ЯЁ][а-яё]{1,49}'),
    "surname"          TEXT NOT NULL
        CONSTRAINT employee__surname CHECK (employee.surname SIMILAR TO '[А-ЯЁ][а-яё]{1,49}'),
    "second_name"      TEXT
        CONSTRAINT employee__second_name CHECK (employee.second_name SIMILAR TO '[А-ЯЁ][а-яё]{4,49}'),
    "date_of_birth"    DATE NOT NULL
        CONSTRAINT employee__date_of_birth CHECK (employee.date_of_birth > '1920-01-01' AND employee.date_of_birth < '2049-12-31'),
    "gender"           TEXT NOT NULL
        CONSTRAINT employee__gender CHECK (employee.gender = 'м' OR employee.gender = 'ж'),
    "address"          TEXT
        CONSTRAINT employee__address CHECK (employee.address SIMILAR TO '[- А-Яа-я0-9«»“”.,]{10,150}'),
    "phone_number"     TEXT
        CONSTRAINT employee__phone_number CHECK (employee.phone_number SIMILAR TO '\+[0-9]{9,16}'),
    "passport_code"    TEXT NOT NULL
        CONSTRAINT employee__passport_code CHECK (employee.passport_code SIMILAR TO '[0-9]{10}'),
    "position_at_work" TEXT NOT NULL
        CONSTRAINT employee__position_at_work CHECK (employee.position_at_work SIMILAR TO '[ А-Я а-я0-9-]{4,50}'),
    "rank"             TEXT
        CONSTRAINT employee__rank CHECK (employee.rank SIMILAR TO '[ А-Яа-я0-9-]{4,50}')
);

CREATE TABLE "model"
(
    "id"              UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),
    "name"            TEXT UNIQUE      NOT NULL
        CONSTRAINT model__name CHECK (model.name SIMILAR TO '[- A-Za-zА-Яа-я0-9]{3,100}'),
    "engine_capacity" DOUBLE PRECISION NOT NULL
        CONSTRAINT model__engine_capacity CHECK (model.engine_capacity > 0.1 AND model.engine_capacity < 10.0),
    "max_speed"       DOUBLE PRECISION NOT NULL
        CONSTRAINT model__max_speed CHECK (model.max_speed > 100.0 AND model.max_speed < 600.0),
    "count_of_doors"  INTEGER          NOT NULL
        CONSTRAINT model__count_of_doors CHECK (model.count_of_doors > 1 AND model.count_of_doors < 9),
    "number_of_seats" INTEGER          NOT NULL
        CONSTRAINT model__number_of_seats CHECK (model.number_of_seats > 1 AND model.number_of_seats < 200)
);

CREATE TABLE "car"
(
    "id"                        UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),
    "brand"                     UUID NOT NULL,
    "model"                     UUID NOT NULL,
    "transmission"              TEXT NOT NULL
        CONSTRAINT car__transmission CHECK (car.transmission = ANY ('{механика,автомат,полуавтомат}')),
    "registration_number"       TEXT NOT NULL
        CONSTRAINT car__registration_number CHECK (car.registration_number SIMILAR TO '[A-Z0-9]{16}'),
    "trailer_number"            TEXT NOT NULL
        CONSTRAINT car__trailer_number CHECK (car.trailer_number SIMILAR TO '[A-Z0-9]{9,12}'),
    "engine_model"              TEXT NOT NULL
        CONSTRAINT car__engine_model CHECK (car.engine_model SIMILAR TO '[- A-Za-zа-яА-Я0-9/]{5,100}'),
    "number_technical_passport" TEXT NOT NULL
        CONSTRAINT car__number_technical_passport CHECK (car.number_technical_passport SIMILAR TO '[0-9]{2}[A-Z]{2}[0-9]{6}'),
    "year_of_release"           DATE NOT NULL
        CONSTRAINT car__year_of_release CHECK (car.year_of_release > '1950-01-01' AND car.year_of_release < '2049-12-31'),
    "color"                     UUID NOT NULL
);

CREATE INDEX "idx_car__brand" ON "car" ("brand");

CREATE INDEX "idx_car__color" ON "car" ("color");

CREATE INDEX "idx_car__model" ON "car" ("model");

ALTER TABLE "car"
    ADD CONSTRAINT "fk_car__brand" FOREIGN KEY ("brand") REFERENCES "brand" ("id") ON DELETE CASCADE;

ALTER TABLE "car"
    ADD CONSTRAINT "fk_car__color" FOREIGN KEY ("color") REFERENCES "color" ("id") ON DELETE CASCADE;

ALTER TABLE "car"
    ADD CONSTRAINT "fk_car__model" FOREIGN KEY ("model") REFERENCES "model" ("id") ON DELETE CASCADE;

CREATE TABLE "cheque"
(
    "id"           UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),
    "employee"     UUID      NOT NULL,
    "client"       UUID      NOT NULL,
    "date_of_sale" TIMESTAMP NOT NULL
        CONSTRAINT cheque__date_of_sale CHECK (cheque.date_of_sale > '2023-01-01' AND cheque.date_of_sale < '2049-12-31'),
    "payment_mark" BOOLEAN   NOT NULL
        DEFAULT false,
    "car"          UUID      NOT NULL
);

CREATE INDEX "idx_cheque__car" ON "cheque" ("car");

CREATE INDEX "idx_cheque__client" ON "cheque" ("client");

CREATE INDEX "idx_cheque__employee" ON "cheque" ("employee");

ALTER TABLE "cheque"
    ADD CONSTRAINT "fk_cheque__car" FOREIGN KEY ("car") REFERENCES "car" ("id") ON DELETE CASCADE;

ALTER TABLE "cheque"
    ADD CONSTRAINT "fk_cheque__client" FOREIGN KEY ("client") REFERENCES "client" ("id") ON DELETE CASCADE;

ALTER TABLE "cheque"
    ADD CONSTRAINT "fk_cheque__employee" FOREIGN KEY ("employee") REFERENCES "employee" ("id") ON DELETE CASCADE;


--
-- CREATE TABLE "car"
-- (
--     "id"    UUID PRIMARY KEY        DEFAULT uuid_generate_v4(),
--     "count" BIGINT         NOT NULL DEFAULT 0 CONSTRAINT positive_count  CHECK (car.count >= 0 AND car.count <= 150),
--     "prise" DECIMAL(12, 2) NOT NULL CONSTRAINT positive_prise  CHECK (car.prise >= 0 )
-- );
--
-- CREATE TABLE "carinfo"
-- (
--     "car"           UUID PRIMARY KEY,
--     "wheel_count"   SMALLINT CONSTRAINT positive_wheel_count CHECK (carinfo.wheel_count >= 0 AND carinfo.wheel_count <= 10) ,
--     "engine_model"  TEXT,
--     "colors"        VARCHAR[]      DEFAULT '{}'::VARCHAR[],
--     "seating_count" BIGINT CONSTRAINT positive_seating_count CHECK (carinfo.seating_count >= 0 AND carinfo.seating_count <= 200),
--     "car_type"      car_type_enum,
--     "other"         JSONB NOT NULL DEFAULT '{}'
-- );
--
-- ALTER TABLE "carinfo"
--     ADD CONSTRAINT "fk_carinfo__car" FOREIGN KEY ("car") REFERENCES "car" ("id");
--
-- CREATE TABLE "consumer"
-- (
--     "id"      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
--     "name"    TEXT,
--     "surname" TEXT
-- );
--
-- CREATE TABLE "consumercompany"
-- (
--     "id"   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
--     "name" TEXT
-- );
--
-- CREATE TABLE "cheque"
-- (
--     "id"               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
--     "consumer"         UUID,
--     "data_of_buy"      TIMESTAMP        DEFAULT now()
--         CONSTRAINT between_datetime
--         CHECK (cheque.data_of_buy > TIMESTAMP '2020-01-01 00:00:00' AND cheque.data_of_buy <= now()),
--     "consumer_company" UUID,
--     "cost"             DECIMAL(12, 2) NOT NULL  CONSTRAINT positive_cost  CHECK (cheque.cost >= 0)
-- );
--
-- CREATE INDEX "idx_cheque__consumer" ON "cheque" ("consumer");
--
-- CREATE INDEX "idx_cheque__consumer_company" ON "cheque" ("consumer_company");
--
-- ALTER TABLE "cheque"
--     ADD CONSTRAINT "fk_cheque__consumer" FOREIGN KEY ("consumer") REFERENCES "consumer" ("id") ON DELETE SET NULL;
--
-- ALTER TABLE "cheque"
--     ADD CONSTRAINT "fk_cheque__consumer_company" FOREIGN KEY ("consumer_company") REFERENCES "consumercompany" ("id") ON DELETE SET NULL;
--
-- CREATE TABLE "cartocheque"
-- (
--     "id"     UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
--     "car"    UUID   NOT NULL,
--     "cheque" UUID   NOT NULL,
--     "count"  BIGINT NOT NULL CONSTRAINT positive_count CHECK (cartocheque.count >= 0 and cartocheque.count <= 150)
-- );
--
-- CREATE INDEX "idx_cartocheque__car" ON "cartocheque" ("car");
--
-- CREATE INDEX "idx_cartocheque__cheque" ON "cartocheque" ("cheque");
--
-- ALTER TABLE "cartocheque"
--     ADD CONSTRAINT "fk_cartocheque__car" FOREIGN KEY ("car") REFERENCES "car" ("id");
--
-- ALTER TABLE "cartocheque"
--     ADD CONSTRAINT "fk_cartocheque__cheque" FOREIGN KEY ("cheque") REFERENCES "cheque" ("id") ON DELETE CASCADE;
--
-- CREATE TABLE "contact"
-- (
--     "id"               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
--     "phone"            TEXT,
--     "email"            TEXT,
--     "postal_code"      TEXT,
--     "address"          TEXT CONSTRAINT positive_count CHECK ,
--     "consumer"         UUID,
--     "consumer_company" UUID
-- );
--
-- CREATE INDEX "idx_contact__consumer" ON "contact" ("consumer");
--
-- CREATE INDEX "idx_contact__consumer_company" ON "contact" ("consumer_company");
--
-- ALTER TABLE "contact"
--     ADD CONSTRAINT "fk_contact__consumer" FOREIGN KEY ("consumer") REFERENCES "consumer" ("id") ON DELETE SET NULL;
--
-- ALTER TABLE "contact"
--     ADD CONSTRAINT "fk_contact__consumer_company" FOREIGN KEY ("consumer_company") REFERENCES "consumercompany" ("id") ON DELETE SET NULL

