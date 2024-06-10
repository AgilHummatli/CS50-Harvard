-- 13. Names of all people who starred in a movie in which Kevin Bacon also starred
select name from people where id in
( select person_id from stars where movie_id in
( select movie_id from stars where person_id =
(select id from people where name = 'Kevin Bacon' AND birth = 1958)))
AND name != 'Kevin Bacon';
