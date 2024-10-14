-- Employee Management System
-- A database to manage employees, departments, roles, salaries, and performance

-- Departments table
-- Stores company departments
CREATE TABLE "departments" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "location" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Roles table
-- Stores job roles/positions within the company
CREATE TABLE "roles" (
    "id" INTEGER,
    "title" TEXT NOT NULL UNIQUE,
    "min_salary" NUMERIC NOT NULL,
    "max_salary" NUMERIC NOT NULL,
    PRIMARY KEY("id")
);

-- Employees table
-- Core table storing all employee information
CREATE TABLE "employees" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "email" TEXT NOT NULL UNIQUE,
    "phone" TEXT,
    "hire_date" DATE NOT NULL DEFAULT CURRENT_DATE,
    "birth_date" DATE,
    "department_id" INTEGER,
    "role_id" INTEGER,
    "manager_id" INTEGER,  -- self-referential: points to another employee
    "status" TEXT NOT NULL DEFAULT 'active' CHECK("status" IN ('active', 'inactive', 'terminated')),
    PRIMARY KEY("id"),
    FOREIGN KEY("department_id") REFERENCES "departments"("id"),
    FOREIGN KEY("role_id") REFERENCES "roles"("id"),
    FOREIGN KEY("manager_id") REFERENCES "employees"("id")
);

-- Salaries table
-- Tracks salary history for each employee over time
CREATE TABLE "salaries" (
    "id" INTEGER,
    "employee_id" INTEGER NOT NULL,
    "amount" NUMERIC NOT NULL,
    "effective_date" DATE NOT NULL,
    "end_date" DATE,  -- NULL means current salary
    PRIMARY KEY("id"),
    FOREIGN KEY("employee_id") REFERENCES "employees"("id")
);

-- Leaves table
-- Tracks employee leave requests (vacation, sick, etc.)
CREATE TABLE "leaves" (
    "id" INTEGER,
    "employee_id" INTEGER NOT NULL,
    "type" TEXT NOT NULL CHECK("type" IN ('vacation', 'sick', 'maternity', 'paternity', 'unpaid')),
    "start_date" DATE NOT NULL,
    "end_date" DATE NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending' CHECK("status" IN ('pending', 'approved', 'rejected')),
    "notes" TEXT,
    PRIMARY KEY("id"),
    FOREIGN KEY("employee_id") REFERENCES "employees"("id")
);

-- Performance reviews table
-- Tracks annual/periodic performance reviews
CREATE TABLE "reviews" (
    "id" INTEGER,
    "employee_id" INTEGER NOT NULL,
    "reviewer_id" INTEGER NOT NULL,  -- the manager conducting the review
    "review_date" DATE NOT NULL,
    "rating" INTEGER NOT NULL CHECK("rating" BETWEEN 1 AND 5),
    "comments" TEXT,
    PRIMARY KEY("id"),
    FOREIGN KEY("employee_id") REFERENCES "employees"("id"),
    FOREIGN KEY("reviewer_id") REFERENCES "employees"("id")
);

-- Projects table
-- Tracks company projects
CREATE TABLE "projects" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "description" TEXT,
    "start_date" DATE NOT NULL,
    "end_date" DATE,
    "status" TEXT NOT NULL DEFAULT 'active' CHECK("status" IN ('active', 'completed', 'cancelled')),
    PRIMARY KEY("id")
);

-- Employee-Project assignments
-- Many-to-many: employees can work on multiple projects
CREATE TABLE "project_assignments" (
    "employee_id" INTEGER NOT NULL,
    "project_id" INTEGER NOT NULL,
    "assigned_date" DATE NOT NULL DEFAULT CURRENT_DATE,
    "role_in_project" TEXT,
    PRIMARY KEY("employee_id", "project_id"),
    FOREIGN KEY("employee_id") REFERENCES "employees"("id"),
    FOREIGN KEY("project_id") REFERENCES "projects"("id")
);

-- Indexes for common lookups

-- Find employees by department quickly
CREATE INDEX "idx_employees_department" ON "employees"("department_id");

-- Find employees by role
CREATE INDEX "idx_employees_role" ON "employees"("role_id");

-- Find employees by manager (org chart queries)
CREATE INDEX "idx_employees_manager" ON "employees"("manager_id");

-- Find current salary quickly (NULL end_date = current)
CREATE INDEX "idx_salaries_employee" ON "salaries"("employee_id", "end_date");

-- Find leave requests by status
CREATE INDEX "idx_leaves_status" ON "leaves"("status");

-- Find reviews by employee
CREATE INDEX "idx_reviews_employee" ON "reviews"("employee_id");

-- Views for common queries

-- View: active employees with their department and role
CREATE VIEW "active_employees" AS
SELECT
    e."id",
    e."first_name" || ' ' || e."last_name" AS "full_name",
    e."email",
    d."name" AS "department",
    r."title" AS "role",
    m."first_name" || ' ' || m."last_name" AS "manager"
FROM "employees" e
LEFT JOIN "departments" d ON e."department_id" = d."id"
LEFT JOIN "roles" r ON e."role_id" = r."id"
LEFT JOIN "employees" m ON e."manager_id" = m."id"
WHERE e."status" = 'active';

-- View: current salaries for all active employees
CREATE VIEW "current_salaries" AS
SELECT
    e."id" AS "employee_id",
    e."first_name" || ' ' || e."last_name" AS "full_name",
    d."name" AS "department",
    r."title" AS "role",
    s."amount" AS "current_salary"
FROM "employees" e
JOIN "salaries" s ON e."id" = s."employee_id"
LEFT JOIN "departments" d ON e."department_id" = d."id"
LEFT JOIN "roles" r ON e."role_id" = r."id"
WHERE s."end_date" IS NULL
AND e."status" = 'active';

-- Sample data

INSERT INTO "departments" ("name", "location") VALUES
('Engineering', 'Baku, Azerbaijan'),
('Human Resources', 'Baku, Azerbaijan'),
('Finance', 'Baku, Azerbaijan'),
('Marketing', 'Baku, Azerbaijan'),
('Operations', 'Baku, Azerbaijan');

INSERT INTO "roles" ("title", "min_salary", "max_salary") VALUES
('Software Engineer', 1500, 4000),
('Senior Software Engineer', 3000, 6000),
('HR Specialist', 1200, 3000),
('Financial Analyst', 1500, 4000),
('Marketing Specialist', 1200, 3000),
('Operations Manager', 2500, 5000),
('Engineering Manager', 4000, 8000),
('CEO', 8000, 20000);

-- Insert CEO first (no manager)
INSERT INTO "employees" ("first_name", "last_name", "email", "phone", "hire_date", "birth_date", "department_id", "role_id", "manager_id", "status")
VALUES ('Anar', 'Mammadov', 'anar.mammadov@company.az', '+994501234567', '2010-01-15', '1975-03-20', 5, 8, NULL, 'active');

-- Insert Engineering Manager
INSERT INTO "employees" ("first_name", "last_name", "email", "phone", "hire_date", "birth_date", "department_id", "role_id", "manager_id", "status")
VALUES ('Nigar', 'Aliyeva', 'nigar.aliyeva@company.az', '+994502345678', '2015-03-01', '1985-07-15', 1, 7, 1, 'active');

-- Insert Software Engineers
INSERT INTO "employees" ("first_name", "last_name", "email", "phone", "hire_date", "birth_date", "department_id", "role_id", "manager_id", "status")
VALUES
('Tural', 'Hasanov', 'tural.hasanov@company.az', '+994503456789', '2020-06-01', '1995-11-10', 1, 1, 2, 'active'),
('Leyla', 'Huseynova', 'leyla.huseynova@company.az', '+994504567890', '2019-09-15', '1993-04-22', 1, 2, 2, 'active'),
('Kamran', 'Rzayev', 'kamran.rzayev@company.az', '+994505678901', '2021-02-10', '1997-08-30', 1, 1, 2, 'active');

-- Insert HR
INSERT INTO "employees" ("first_name", "last_name", "email", "phone", "hire_date", "birth_date", "department_id", "role_id", "manager_id", "status")
VALUES ('Sabina', 'Quliyeva', 'sabina.quliyeva@company.az', '+994506789012', '2018-04-20', '1990-12-05', 2, 3, 1, 'active');

-- Insert Finance
INSERT INTO "employees" ("first_name", "last_name", "email", "phone", "hire_date", "birth_date", "department_id", "role_id", "manager_id", "status")
VALUES ('Elnur', 'Babayev', 'elnur.babayev@company.az', '+994507890123', '2017-07-01', '1988-06-18', 3, 4, 1, 'active');

-- Salaries (current salaries have NULL end_date)
INSERT INTO "salaries" ("employee_id", "amount", "effective_date", "end_date") VALUES
(1, 12000, '2010-01-15', NULL),
(2, 5500, '2015-03-01', NULL),
(3, 2000, '2020-06-01', '2022-06-01'),
(3, 2500, '2022-06-01', NULL),  -- got a raise
(4, 4500, '2019-09-15', NULL),
(5, 1800, '2021-02-10', NULL),
(6, 2200, '2018-04-20', NULL),
(7, 3000, '2017-07-01', NULL);

-- Leave requests
INSERT INTO "leaves" ("employee_id", "type", "start_date", "end_date", "status", "notes") VALUES
(3, 'vacation', '2024-07-01', '2024-07-14', 'approved', 'Summer vacation'),
(4, 'sick', '2024-03-10', '2024-03-12', 'approved', 'Flu'),
(5, 'vacation', '2024-08-01', '2024-08-07', 'pending', NULL);

-- Performance reviews
INSERT INTO "reviews" ("employee_id", "reviewer_id", "review_date", "rating", "comments") VALUES
(3, 2, '2023-12-01', 4, 'Good progress, meets expectations'),
(4, 2, '2023-12-01', 5, 'Exceptional performance, promoted to senior'),
(5, 2, '2023-12-01', 3, 'Meets expectations, room for improvement'),
(6, 1, '2023-12-01', 4, 'Reliable and consistent'),
(7, 1, '2023-12-01', 5, 'Outstanding financial analysis');

-- Projects
INSERT INTO "projects" ("name", "description", "start_date", "end_date", "status") VALUES
('Core Banking System', 'Upgrade the core banking infrastructure', '2024-01-01', NULL, 'active'),
('HR Portal', 'Build internal HR self-service portal', '2023-06-01', '2024-01-01', 'completed'),
('Mobile App', 'Customer-facing mobile application', '2024-03-01', NULL, 'active');

-- Project assignments
INSERT INTO "project_assignments" ("employee_id", "project_id", "assigned_date", "role_in_project") VALUES
(2, 1, '2024-01-01', 'Project Lead'),
(3, 1, '2024-01-01', 'Backend Developer'),
(4, 1, '2024-01-01', 'Senior Developer'),
(5, 3, '2024-03-01', 'Backend Developer'),
(4, 3, '2024-03-01', 'Tech Lead');
