ALTER TABLE cheque
    DROP CONSTRAINT IF EXISTS fk_cheque__car,
    DROP CONSTRAINT IF EXISTS fk_cheque__client,
    DROP CONSTRAINT IF EXISTS fk_cheque__employee
;

ALTER TABLE car
    DROP CONSTRAINT IF EXISTS fk_car__brand,
    DROP CONSTRAINT IF EXISTS fk_car__color,
    DROP CONSTRAINT IF EXISTS fk_car__model
;



DROP INDEX IF EXISTS
    idx_car__brand
    , idx_car__color
    , idx_car__model
    , idx_cheque__car
    , idx_cheque__client
    , idx_cheque__employee
    RESTRICT;

drop table if exists cheque
    , client
    , employee
    , car
    , brand
    , color
    , model;


-- DROP TYPE IF EXISTS car_type_enum;

drop extension if exists "uuid-ossp";