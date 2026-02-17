-- 3. Titles of all movies since 2018, in alphabetical order
select title from movies where year >= 2018 order by title ASC;
