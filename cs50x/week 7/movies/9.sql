-- 9. Names of all people who starred in a movie released in 2004, ordered by birth year
SELECT id, name from people where id in ( select distinct person_id from stars where movie_id in (select id from movies where year = 2004)) order by birth asc;
