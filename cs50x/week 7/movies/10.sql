-- 10. Names of all directors who have directed a movie that got a rating of at least 9.0
select distinct name from people where id in (select person_id from directors where movie_id in (select movie_id from ratings where rating >= 9.0));
