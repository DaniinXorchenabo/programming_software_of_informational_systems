-- Трансформация таблицы

ALTER TABLE client
    DROP CONSTRAINT client__phone_number
    , ALTER COLUMN phone_number
        SET DATA TYPE bigint
        using cast ( phone_number as bigint)
    , ADD COLUMN useless text
    ;

-- Возвращение обратно
ALTER TABLE client
    ALTER COLUMN phone_number
        SET DATA TYPE text
        using '+' || cast ( phone_number as text)
    , ADD CONSTRAINT client__phone_number CHECK (client.phone_number SIMILAR TO '\+[0-9]{9,16}')
    , DROP COLUMN useless
    ;
