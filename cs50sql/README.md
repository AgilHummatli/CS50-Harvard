# CS50 SQL — Introduction to Databases with SQL

**Harvard University / CS50's Introduction to Databases with SQL**
7 problem sets · 1 final project · Certificate awarded 2026

> "SQL is deceptively simple. The first query takes five minutes. Designing a schema that doesn't fall apart at scale takes years."

---

## What This Course Is

A dedicated SQL course covering databases from the ground up: how to query data, how to design schemas, how to make queries fast, and how to think about data modeling for the real world.

Not just SELECT * FROM table. The course goes deep into normalization, indexing, transactions, triggers, views, and connecting SQL to other languages. Datasets are real: Cyberchase episodes, baseball stats, Boston public schools, Airbnb listings, meteorite landings, Harvard enrollment data.

---

## Course Structure

| Week | Topic | Problem Set |
|------|-------|------------|
| 0 | Querying | Cyberchase, Players, Views from a Room |
| 1 | Relating | DESE, Moneyball, The Lost Letter |
| 2 | Designing | ATL, Connect, Donuts |
| 3 | Writing | Don't Panic, Meteorites |
| 4 | Viewing | BnB, Census, Private Eye |
| 5 | Optimizing | Harvard, Snap |
| 6 | Scaling | Deep Dive, Don't Panic Python, Sentimental Connect |
| — | Final Project | Employee Management System |

---

## Problem Sets

**Week 0 — Querying (Cyberchase, Players, Views from a Room)**
First contact with SQL. SELECT, WHERE, ORDER BY, LIMIT, LIKE. Querying a database of Cyberchase episodes, baseball player stats, and artwork in museum collections. Learning how to ask questions of data that already exists.

**Week 1 — Relating (DESE, Moneyball, The Lost Letter)**
JOINs. Connecting multiple tables through foreign keys. Querying Massachusetts school district data (DESE) across multiple related tables. Moneyball: analyzing player salaries and performance like the Oakland A's front office. The Lost Letter: tracking a package through a delivery system by tracing relationships across tables.

**Week 2 — Designing (ATL, Connect, Donuts)**
Schema design from scratch. Given a real-world scenario, design the tables, columns, types, constraints, and relationships. Atlanta airport: model flights, gates, airlines, passengers. Connect four: model a game board. Donuts: model a bakery's products, orders, and ingredients. Learning to think about what data looks like before it exists.

**Week 3 — Writing (Don't Panic, Meteorites)**
INSERT, UPDATE, DELETE. Modifying data, not just reading it. Don't Panic: gain admin access to a database by resetting a password — understanding how SQL injection and privilege escalation work from the inside. Meteorites: import and clean a CSV of 45,000 meteorite landings, handle NULLs, round coordinates, delete bad rows.

**Week 4 — Viewing (BnB, Census, Private Eye)**
Views: saved SELECT queries that act like virtual tables. BnB: create views over Airbnb listing data to answer business questions (available listings, frequently reviewed, June vacancies, one-bedroom apartments). Census: aggregate India census data by district and region. Private Eye: decode a hidden message using views as a tool.

**Week 5 — Optimizing (Harvard, Snap)**
Indexes: how databases speed up queries using B-trees. Harvard enrollment data: identify which queries are slow and add the right indexes to fix them. Snap social network: write efficient queries over a large social graph. Understanding EXPLAIN QUERY PLAN and how the query planner uses indexes.

**Week 6 — Scaling (Deep Dive, Don't Panic Python, Sentimental Connect)**
Moving beyond SQLite. PostgreSQL and MySQL for production scale. Don't Panic in Python: repeat the Week 3 hack but using Python's sqlite3 module programmatically. Sentimental Connect: redesign the Connect Four schema but now in MySQL. Deep Dive: written analysis of database design decisions at scale.

---

## Final Project — Employee Management System

**[View Project →](final/project/)**

A complete relational database designed to manage employees, departments, roles, salaries, and performance reviews for an organization.

**Schema highlights:**
- `employees` table with hire date, status, manager reference (self-referential foreign key for org hierarchy)
- `departments` with budget tracking
- `roles` with salary bands
- `salaries` as a history table (every change recorded, not just current)
- `performance_reviews` linked to employees and reviewers
- `projects` and `employee_projects` for many-to-many assignment tracking

**Design decisions documented in DESIGN.md:**
- Why salary history is a separate table instead of a column on employees
- Why the org chart uses a self-referential key instead of a separate hierarchy table
- Index strategy: which columns get indexes and why
- Normalization choices: what's in 3NF and what deliberate denormalizations were made for query performance

**Queries included:** Employee directory with full chain of management, department headcount and average salary, salary history per employee, performance trend analysis, project staffing reports.

---

## What I Learned

**JOINs are the core skill.** Most useful SQL is multi-table. Understanding INNER JOIN vs LEFT JOIN vs self-joins changed how I think about related data. A LEFT JOIN that returns NULLs is telling you something important — items that exist in one table but not another.

**Schema design is harder than querying.** You can always write a different query. You can't easily restructure a table with millions of rows in production. Getting the schema right — the right normal forms, the right foreign keys, the right NULL policy — is the real work.

**Indexes are not magic.** An index on the wrong column does nothing. An index on a column you UPDATE frequently slows down writes to speed up reads. Every index is a trade-off. Using EXPLAIN QUERY PLAN to verify that your index is actually being used is essential.

**NULL is not zero.** NULL means unknown. Arithmetic with NULL produces NULL. Comparisons with NULL require IS NULL, not = NULL. Forgetting this causes subtle, hard-to-find bugs in aggregations and JOINs.

**Transactions protect data integrity.** If two things must happen together (debit one account, credit another), they need to be in a transaction. If one fails, both must roll back. Without transactions, partial updates corrupt your data.

---

## Certificate

[View Certificate](https://cs50.harvard.edu/certificates/ba09128c-0888-489b-87c6-36ccc99b7f28)

Awarded 2026 · Harvard University · David J. Malan

---

## Stats

| | |
|---|---|
| Problem Sets | 7 (20 individual SQL files) |
| Final Project | Employee Management System |
| Weeks | 6 + final |
| Year completed | 2026 |
| Platform | edX / cs50.harvard.edu |
