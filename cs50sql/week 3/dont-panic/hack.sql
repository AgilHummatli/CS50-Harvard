-- Step 1: Change admin's password to MD5 of "oops!"
UPDATE "users"
SET "password" = '982c0381c279d139fd221fce974916e7'
WHERE "username" = 'admin';

-- Step 2: Erase the real log of the password change
DELETE FROM "user_logs"
WHERE "type" = 'update'
AND "new_password" = '982c0381c279d139fd221fce974916e7';

-- Step 3: Insert a false log framing emily33
INSERT INTO "user_logs" ("type", "old_username", "new_username", "old_password", "new_password")
VALUES (
    'update',
    'admin',
    'admin',
    (SELECT "password" FROM "users" WHERE "username" = 'admin'),
    (SELECT "password" FROM "users" WHERE "username" = 'emily33')
);
