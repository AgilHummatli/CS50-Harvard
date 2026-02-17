-- 5. Titles and years of all Harry Potter movies, in chronological order (title beginning with "Harry Potter and the ...")
select title, year from movies where title like 'Harry Potter and the%' order by year asc;
