SELECT "first_name", "last_name"
FROM (
    SELECT "first_name", "last_name", "id" FROM (
        SELECT "first_name", "last_name", "players"."id" AS "id"
        FROM "players"
        JOIN "salaries" ON "players"."id" = "salaries"."player_id"
        JOIN "performances" ON "players"."id" = "performances"."player_id"
            AND "salaries"."year" = "performances"."year"
        WHERE "salaries"."year" = 2001 AND "H" > 0
        ORDER BY ("salary" / "H") ASC, "players"."id" ASC
        LIMIT 10
    )
    INTERSECT
    SELECT "first_name", "last_name", "id" FROM (
        SELECT "first_name", "last_name", "players"."id" AS "id"
        FROM "players"
        JOIN "salaries" ON "players"."id" = "salaries"."player_id"
        JOIN "performances" ON "players"."id" = "performances"."player_id"
            AND "salaries"."year" = "performances"."year"
        WHERE "salaries"."year" = 2001 AND "RBI" > 0
        ORDER BY ("salary" / "RBI") ASC, "players"."id" ASC
        LIMIT 10
    )
)
ORDER BY "id" ASC;
