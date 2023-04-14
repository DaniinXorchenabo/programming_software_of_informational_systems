create type journal_type as enum ('create', 'update', 'delete');
CREATE TABLE cheque_journal
(
    "id_of_journal" UUID PRIMARY KEY      default uuid_generate_v4(),
    "journal_type"  journal_type NOT NULL,
    "datetime"      timestamp    NOT NULL DEFAULT now(),
    "cheque_id"     UUID         NOT NULL,
    "employee"      UUID,
    "client"        UUID,
    "date_of_sale"  TIMESTAMP,
    "payment_mark"  BOOLEAN,
    "car"           UUID
);


CREATE OR REPLACE FUNCTION cheque_journal_controller()
    RETURNS TRIGGER AS
$cheque_journal_controller$
BEGIN
    --
    -- Create a row in emp_audit to reflect the operation performed on emp,
    -- make use of the special variable TG_OP to work out the operation.
    --
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO cheque_journal select uuid_generate_v4(), 'delete', now(), OLD.*;
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO cheque_journal SELECT uuid_generate_v4(), 'update', now(), NEW.*;
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO cheque_journal SELECT uuid_generate_v4(), 'create', now(), NEW.*;
        RETURN NEW;
    END IF;
    RETURN NULL; -- result is ignored since this is an AFTER trigger
END;
$cheque_journal_controller$ LANGUAGE plpgsql;

-- After триггер на добавление
CREATE  TRIGGER  add_cheque_to_journal__trigger
   AFTER INSERT
    ON cheque
    FOR EACH row EXECUTE FUNCTION cheque_journal_controller();

-- After триггер на обновление
CREATE  TRIGGER update_cheque_to_journal__trigger
   AFTER UPDATE
    ON cheque
    FOR EACH ROW EXECUTE FUNCTION cheque_journal_controller();

-- After триггер на удаление
CREATE TRIGGER delete_cheque_to_journal__trigger
   AFTER DELETE
    ON cheque
    FOR EACH ROW EXECUTE FUNCTION cheque_journal_controller();


drop trigger add_cheque_to_journal__trigger on cheque ;
drop trigger update_cheque_to_journal__trigger on cheque ;
drop trigger delete_cheque_to_journal__trigger on cheque ;

select  substr('123456789', 2, length('123456789') - 1);



create or replace function correction_phone_number()
    RETURNS TRIGGER AS
$cheque_journal_controller$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        if (NEW.phone_number like '8%') then
            NEW.phone_number := '+7' ||  substr(NEW.phone_number, 2, length(NEW.phone_number) - 1);
        end if;
        RETURN NEW;
    END IF;
    RETURN NULL; -- result is ignored since this is an AFTER trigger
END;
$cheque_journal_controller$ LANGUAGE plpgsql;

CREATE TRIGGER correct_client_phone_number__trigger
   before INSERT
    ON client
    FOR EACH ROW EXECUTE FUNCTION correction_phone_number();

drop trigger correct_client_phone_number__trigger on client;