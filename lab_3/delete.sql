insert into color (id, color_name)
VALUES ('c9b93e09-205d-401c-9eee-0f7da6928bdd', 'Серо-буро-малиновый')
returning id, color_name;
insert into brand (id, name)
VALUES ('fa03ec04-7f2e-48b5-a7a0-2e78b41dfaa6', 'Джип')
returning id, name;
INSERT INTO model (id, name, engine_capacity, max_speed, count_of_doors, number_of_seats)
VALUES ('15ebd922-a4ff-49ba-84d5-4cc4ef0bb92e', 'Bwestfalia', 0.9, 180, 4, 5)
returning id, name;

delete from color
where id = 'c9b93e09-205d-401c-9eee-0f7da6928bdd'
returning id, color_name;

delete from brand
where id = 'fa03ec04-7f2e-48b5-a7a0-2e78b41dfaa6'
returning id, name;

delete from model
where id = '15ebd922-a4ff-49ba-84d5-4cc4ef0bb92e'
returning id, name;
