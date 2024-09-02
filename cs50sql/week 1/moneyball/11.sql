SELECT "first_name", "last_name", ("salary" / "H") AS "dollars per hit"
FROM "players"
JOIN "salaries" ON "players"."id" = "salaries"."player_id"
JOIN "performances" ON "players"."id" = "performances"."player_id"
    AND "salaries"."year" = "performances"."year"
WHERE "salaries"."year" = 2001 AND "H" > 0
ORDER BY "dollars per hit" ASC, "first_name" ASC, "last_name" ASC
LIMIT 10;
