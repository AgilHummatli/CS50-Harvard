-- 6. Average rating of movies in 2012
SELECT avg(rating) from ratings where movie_id IN (select id from movies where year = 2012);
