---
marp: true
theme: default
paginate: true
size: 16:9
---

<!--
_class: lead invert
_paginate: false
-->

# Relational Databases & SQL
# Structured Query Language

**Course:** NoSQL Databases

---

# Relational Model Anatomy

Core Concepts:

- `Table` (Relation): A rigid, two-dimensional structure (rows and columns).
- `Row` (Tuple / Record): A single object in the database (e.g., a specific student).
- `Column` (Attribute): An object property with a strictly defined data type (INT, VARCHAR, TIMESTAMP).

> _Relational database:
collection of schema-linked tables resembling spreadsheets with very strict rules_

---

# Relationships (Linking Data)

- `Primary Key` (PK): A unique identifier for a record in a table (e.g., student_id).
- `Foreign Key` (FK): A pointer in one table referencing the Primary Key in another table.
- Relationship Types:
  - `1 : 1` (One-to-One)
  - `1 : N` (One-to-Many – most common, e.g., One student $\rightarrow$ Many orders)
  - `N : M` (Many-to-Many – requires a junction/bridge table)

---

# SQL Language

**Declarative Querying: HOW vs WHAT**

- Query Structure:

    ```sql
    SELECT s.first_name, o.amount 
    FROM students s
    JOIN orders o ON s.id = o.student_id
    WHERE o.status = 'COMPLETED';
    ```

- Core Operations:

    - Projection and Selection: SELECT, WHERE
    - Joining Tables: JOIN (INNER, LEFT, RIGHT) – the cornerstone of relationality
    - Aggregation: GROUP BY, COUNT(), SUM(), AVG()

---

# Core SQL Statements

- DDL (Data Definition): CREATE, ALTER, DROP
- DML (Data Manipulation): INSERT, UPDATE, DELETE
- DQL (Data Query): SELECT, FROM, WHERE, JOIN, GROUP BY

---

# Transaction Management

```sql
BEGIN;

  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  UPDATE accounts SET balance = balance + 100 WHERE id = 2;

COMMIT;
```
---

# The Need for NoSQL

Why were alternatives created?

- Rigid Schema: Difficulty modifying table structures on a live, production database.
- Vertical vs. Horizontal Scaling:

    - SQL (Scale-Up): Increasing server capacity (more CPU, RAM). An expensive and physically limited process.
    - NoSQL (Scale-Out): Adding more low-cost nodes/servers to a cluster.

- The Cost of Expensive JOINs: Joining tables across tens of millions of records severely slows down the system.

---

# SQL vs. NoSQL Databases

| Feature | Relational (SQL) | Non-Relational (NoSQL) |
| :--- | :--- | :--- |
| **Data Model** | Tables, rows, columns | Documents, Key-Value, Graphs, Wide-Column |
| **Schema** | Rigid (Schema First) | Flexible / Dynamic Schema |
| **Scaling** | Vertical (Scale-Up) | Horizontal (Scale-Out) |
| **Guarantees** | Strong Consistency | Flexible Consistency |
| **Primary Use Cases** | Financial systems, ERP, CRM | Big Data, Real-time analytics, Caching |

---

<!--
_class: lead invert
_paginate: false
-->

# Practical Tasks

---

# Task 1: Database Setup

Run the `employees.sql` to create the table structure and insert the sample dataset.
Then write SELECT queries to fulfill the following business requests:

1. Basic Projection: Retrieve only the first_name, last_name, department, and salary for all employees.
2. Filtering by Value (WHERE): Find all employees working in the 'Engineering' department.
3. Multiple Conditions (AND / OR): List all remote workers (is_remote = true) who earn more than $80,000.

---

4. Range Filtering (BETWEEN): Find all employees hired between January 1, 2021 and December 31, 2022, ordered by hire_date from oldest to newest.
5. Pattern Matching (LIKE / ILIKE): Retrieve all employees whose job_title contains the word 'Manager'.
6. Sorting and Limits (ORDER BY & LIMIT): Find the top 3 highest-paid employees in the entire company.
7. Basic Aggregation (COUNT, AVG): Calculate the total number of employees and the average salary across the company.
8. Grouping Data (GROUP BY): Calculate the average salary and employee count for each department.
9. Filtering Groups (HAVING): Display departments that have an average salary greater than $80,000.

---

# Task 2: Designing & Implementing Relational Schema (DDL)

**Scenario:**

You are tasked with designing a lightweight database schema for a simple **Conference Room Booking System**. The system needs to keep track of available rooms, registered users, and bookings made by users.

---

1. Create the rooms table:
   - `id`: Auto-incrementing primary key (SERIAL).
   - `room_name`: A non-null string up to 50 characters, must be unique.
   - `capacity`: An integer greater than 0 (CHECK).
   - `has_projector`: A boolean value with a default of true.

2. Create the users table:
   - `id`: Auto-incrementing primary key (SERIAL).
   - `full_name`: A non-null string up to 100 characters.
   - `email`: A unique, non-null string up to 100 characters.

---

3. Create the bookings table:
   - `id`: Auto-incrementing primary key (SERIAL).
   - `room_id`: Foreign key referencing rooms(id) with ON DELETE CASCADE.
   - `user_id`: Foreign key referencing users(id) with ON DELETE CASCADE.
   - `booking_date`: Date of the reservation (non-null).
   - `duration_hours`: An integer between 1 and 8 (CHECK).
  
4. Add data:

---

```sql
-- Insert Rooms
INSERT INTO rooms (room_name, capacity, has_projector) VALUES
('Boardroom A', 12, true),
('Focus Room B', 4, false),
('Auditorium C', 50, true);

-- Insert Users
INSERT INTO users (full_name, email) VALUES
('Alice Johnson', 'alice.johnson@example.com'),
('Bob Smith', 'bob.smith@example.com'),
('Charlie Brown', 'charlie.brown@example.com');

-- Insert Bookings
INSERT INTO bookings (room_id, user_id, booking_date, duration_hours) VALUES
(1, 1, '2026-09-20', 2), -- Alice booked Boardroom A
(1, 2, '2026-09-21', 4), -- Bob booked Boardroom A
(2, 1, '2026-09-22', 1), -- Alice booked Focus Room B
(3, 3, '2026-09-20', 3); -- Charlie booked Auditorium C
```

---

**Operation A: Basic Retrieval & Join**

Write a query to retrieve all bookings showing the user's full name, room name, booking date, and duration in hours.

---

**Operation B: Constraint Validation (Expected Errors)**

Execute queries to observe how PostgreSQL enforces database constraints.

---

Duplicate Email Violation (UNIQUE constraint).

```sql
INSERT INTO users (full_name, email) 
VALUES ('Duplicate User', 'alice.johnson@example.com');
```
> Fails because `email` must be unique

---

Invalid Room Capacity (CHECK constraint)

```sql
INSERT INTO rooms (room_name, capacity, has_projector) 
VALUES ('Tiny Closet', 0, false);
```

> Fails because `capacity` must be greater than 0

---

Invalid Booking Duration (CHECK constraint)

```sql
INSERT INTO bookings (room_id, user_id, booking_date, duration_hours) 
VALUES (1, 1, '2026-09-25', 10);
```

> Fails because `duration_hours` must be between 1 and 8

---

**Operation C: Cascading Deletion (ON DELETE CASCADE)**

Delete a user and observe the automatic cleanup of their associated bookings:

```sql
-- Delete user 'Alice Johnson'
DELETE FROM users WHERE email = 'alice.johnson@example.com';

-- Verify that Alice's bookings were automatically removed from the bookings table
SELECT * FROM bookings;
```

---

# Task 3: Multi-Table Analytics & Business Reporting (JOINs, Aggregation & Views)

**Scenario:**

You are building an analytics dashboard for an E-Commerce platform. The database stores information about customers, orders, and order items. Your goal is to write analytical queries to answer key business performance questions and encapsulate complex queries into reusable SQL Views.

**Database Setup**
Run the ecommerce.sql to create the required tables and populate them with test data.

---

**Operation A: Customer Order History (`JOIN` & Filtering)**

Write a query to display all COMPLETED orders. The output should include:

- `full_name` (Customer)
- `country`
- `order_id`
- `order_date`

---

**Operation B: Revenue Calculation (`JOIN`, `SUM`, `GROUP BY`)**

Calculate the total monetary value spent by each customer.

- Multiply `quantity * unit_price` to get item totals.
- Group the results by customer `full_name`.
- Display only `COMPLETED` orders.

---

**Operation C: High-Value Customers (`HAVING`)**

Modify the query from Operation B to show only customers who have spent a total of more than $300.00 across all completed orders.

---

**Operation D: Business View Creation (`CREATE VIEW`)**

Encapsulate the query from Operation B into a reusable view named `v_customer_revenue`:

```sql
CREATE VIEW v_customer_revenue AS
SELECT ...
```

Once created, query the view directly:

```sql
SELECT * FROM v_customer_revenue WHERE country = 'USA';
```

