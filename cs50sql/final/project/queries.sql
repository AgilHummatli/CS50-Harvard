-- Employee Management System - Common Queries

-- SELECT QUERIES

-- Get all active employees with their department and role
SELECT * FROM "active_employees";

-- Get all current salaries
SELECT * FROM "current_salaries";

-- Find all employees in a specific department
SELECT "full_name", "role", "email"
FROM "active_employees"
WHERE "department" = 'Engineering';

-- Get the full org chart: each employee and their manager
SELECT
    e."first_name" || ' ' || e."last_name" AS "employee",
    r."title" AS "role",
    m."first_name" || ' ' || m."last_name" AS "manager"
FROM "employees" e
LEFT JOIN "employees" m ON e."manager_id" = m."id"
LEFT JOIN "roles" r ON e."role_id" = r."id"
WHERE e."status" = 'active'
ORDER BY m."last_name", e."last_name";

-- Find all direct reports of a specific manager
SELECT
    e."first_name" || ' ' || e."last_name" AS "employee",
    r."title" AS "role"
FROM "employees" e
JOIN "roles" r ON e."role_id" = r."id"
WHERE e."manager_id" = (
    SELECT "id" FROM "employees"
    WHERE "email" = 'nigar.aliyeva@company.az'
);

-- Get salary history for a specific employee
SELECT
    e."first_name" || ' ' || e."last_name" AS "employee",
    s."amount",
    s."effective_date",
    s."end_date"
FROM "salaries" s
JOIN "employees" e ON s."employee_id" = e."id"
WHERE e."email" = 'tural.hasanov@company.az'
ORDER BY s."effective_date";

-- Get average salary by department
SELECT
    d."name" AS "department",
    ROUND(AVG(s."amount"), 2) AS "avg_salary",
    MIN(s."amount") AS "min_salary",
    MAX(s."amount") AS "max_salary"
FROM "salaries" s
JOIN "employees" e ON s."employee_id" = e."id"
JOIN "departments" d ON e."department_id" = d."id"
WHERE s."end_date" IS NULL
AND e."status" = 'active'
GROUP BY d."name"
ORDER BY "avg_salary" DESC;

-- Find all pending leave requests
SELECT
    e."first_name" || ' ' || e."last_name" AS "employee",
    l."type",
    l."start_date",
    l."end_date",
    l."notes"
FROM "leaves" l
JOIN "employees" e ON l."employee_id" = e."id"
WHERE l."status" = 'pending';

-- Get all employees currently on a project
SELECT
    p."name" AS "project",
    e."first_name" || ' ' || e."last_name" AS "employee",
    pa."role_in_project"
FROM "project_assignments" pa
JOIN "employees" e ON pa."employee_id" = e."id"
JOIN "projects" p ON pa."project_id" = p."id"
WHERE p."status" = 'active'
ORDER BY p."name", e."last_name";

-- Get latest performance review for each employee
SELECT
    e."first_name" || ' ' || e."last_name" AS "employee",
    r."rating",
    r."review_date",
    r."comments",
    m."first_name" || ' ' || m."last_name" AS "reviewer"
FROM "reviews" r
JOIN "employees" e ON r."employee_id" = e."id"
JOIN "employees" m ON r."reviewer_id" = m."id"
WHERE r."review_date" = (
    SELECT MAX("review_date")
    FROM "reviews"
    WHERE "employee_id" = r."employee_id"
)
ORDER BY r."rating" DESC;

-- Count employees per department
SELECT
    d."name" AS "department",
    COUNT(e."id") AS "headcount"
FROM "departments" d
LEFT JOIN "employees" e ON d."id" = e."department_id"
AND e."status" = 'active'
GROUP BY d."name"
ORDER BY "headcount" DESC;

-- INSERT QUERIES

-- Add a new employee
INSERT INTO "employees" ("first_name", "last_name", "email", "phone", "hire_date", "birth_date", "department_id", "role_id", "manager_id", "status")
VALUES (
    'Aysel',
    'Nazarova',
    'aysel.nazarova@company.az',
    '+994508901234',
    '2024-09-01',
    '1998-05-14',
    (SELECT "id" FROM "departments" WHERE "name" = 'Engineering'),
    (SELECT "id" FROM "roles" WHERE "title" = 'Software Engineer'),
    (SELECT "id" FROM "employees" WHERE "email" = 'nigar.aliyeva@company.az'),
    'active'
);

-- Set starting salary for new employee
INSERT INTO "salaries" ("employee_id", "amount", "effective_date", "end_date")
VALUES (
    (SELECT "id" FROM "employees" WHERE "email" = 'aysel.nazarova@company.az'),
    1800,
    '2024-09-01',
    NULL
);

-- Submit a leave request
INSERT INTO "leaves" ("employee_id", "type", "start_date", "end_date", "status", "notes")
VALUES (
    (SELECT "id" FROM "employees" WHERE "email" = 'tural.hasanov@company.az'),
    'vacation',
    '2024-12-23',
    '2024-12-31',
    'pending',
    'New Year holiday'
);

-- Add a performance review
INSERT INTO "reviews" ("employee_id", "reviewer_id", "review_date", "rating", "comments")
VALUES (
    (SELECT "id" FROM "employees" WHERE "email" = 'tural.hasanov@company.az'),
    (SELECT "id" FROM "employees" WHERE "email" = 'nigar.aliyeva@company.az'),
    '2024-12-01',
    4,
    'Strong year, good technical growth'
);

-- UPDATE QUERIES

-- Give an employee a raise (close old salary, open new one)
UPDATE "salaries"
SET "end_date" = '2024-09-01'
WHERE "employee_id" = (
    SELECT "id" FROM "employees" WHERE "email" = 'tural.hasanov@company.az'
)
AND "end_date" IS NULL;

INSERT INTO "salaries" ("employee_id", "amount", "effective_date", "end_date")
VALUES (
    (SELECT "id" FROM "employees" WHERE "email" = 'tural.hasanov@company.az'),
    3000,
    '2024-09-01',
    NULL
);

-- Promote an employee to a new role
UPDATE "employees"
SET "role_id" = (SELECT "id" FROM "roles" WHERE "title" = 'Senior Software Engineer')
WHERE "email" = 'tural.hasanov@company.az';

-- Approve a leave request
UPDATE "leaves"
SET "status" = 'approved'
WHERE "employee_id" = (
    SELECT "id" FROM "employees" WHERE "email" = 'tural.hasanov@company.az'
)
AND "start_date" = '2024-12-23';

-- Mark an employee as terminated
UPDATE "employees"
SET "status" = 'terminated'
WHERE "email" = 'kamran.rzayev@company.az';

-- DELETE QUERIES

-- Remove an employee from a project
DELETE FROM "project_assignments"
WHERE "employee_id" = (
    SELECT "id" FROM "employees" WHERE "email" = 'kamran.rzayev@company.az'
)
AND "project_id" = (
    SELECT "id" FROM "projects" WHERE "name" = 'Core Banking System'
);

-- Cancel a pending leave request
DELETE FROM "leaves"
WHERE "employee_id" = (
    SELECT "id" FROM "employees" WHERE "email" = 'leyla.huseynova@company.az'
)
AND "status" = 'pending';
