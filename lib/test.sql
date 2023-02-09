create table users (id int, nome text);
insert into users (id, nome) values (1, 'M'), (2, 'Y'), (3, 'D'), (4, 'E'), (5, 'F'), (6, 'R');
create table teams (id int, nome text);
insert into teams (id, nome) values (1, 'MY'), (2, 'ED'), (3, 'EDF'), (4, 'ME'), (5, 'MYR');
create table players (id int , user_id int, team_id int);
insert into players (id, user_id, team_id) values (1, 1, 1), (2, 1, 4), (3, 1, 5), (4, 2, 1), 
(5, 2, 5), (6, 3, 2), (7, 3, 3), (8, 4, 2), (9, 4, 3), (10, 4, 4), (11, 5, 3), (12, 6, 5);
create table demos (id int, nome text, time_vencedor_id int, time_perdedor_id int);
insert into demos (id, nome, time_vencedor_id, time_perdedor_id) values
(1, 'Demo 1', 1, 2), (2, 'Demo 2', 1, 2), (3, 'Demo 4', 2, 4), (4, 'Demo 4', 5, 3);

SELECT d.id FROM demos d
INNER JOIN teams tv ON d.time_vencedor_id = tv.id
INNER JOIN players ptv ON ptv.team_id = tv.id
WHERE ptv.user_id = 1
INTERSECT
SELECT d.id FROM demos d
INNER JOIN teams tv ON d.time_vencedor_id = tv.id
INNER JOIN players ptv ON ptv.team_id = tv.id
WHERE ptv.user_id = 6

-- ActiveRecord::Base.connection.exec_query(
--   "SELECT COUNT(subquery.id) FROM (
--     SELECT d.id FROM demos d
--     INNER JOIN teams tv ON d.time_vencedor_id = tv.id
--     INNER JOIN players ptv ON ptv.team_id = tv.id
--     WHERE ptv.user_id = #{1}
--     INTERSECT
--     SELECT d.id FROM demos d
--     INNER JOIN teams tv ON d.time_vencedor_id = tv.id
--     INNER JOIN players ptv ON ptv.team_id = tv.id
--     WHERE ptv.user_id = #{2}) AS subquery"
-- )