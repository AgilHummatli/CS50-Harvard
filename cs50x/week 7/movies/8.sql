-- 8. Names of people who starred in Toy Story
SELECT name from people where id IN (select person_id from stars where movie_id IN(select id from movies where title = 'Toy Story'));
