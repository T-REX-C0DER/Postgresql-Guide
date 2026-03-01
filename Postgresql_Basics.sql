/* ============================================================
   POSTGRESQL BASICS GUIDE
   Author: (Your Name)
   Description: PostgreSQL basic definitions, rules, and commands
   Safe to run in psql / pgAdmin
   ============================================================ */


-- ============================================================
-- 1. WHAT IS POSTGRESQL?
-- ============================================================
-- PostgreSQL is an open-source Relational Database Management System (RDBMS)
-- It stores data in tables and supports advanced SQL queries.
-- It is ACID compliant and supports JSON, indexing, transactions, etc.


-- ============================================================
-- 2. CORE DATABASE CONCEPTS
-- ============================================================

-- Database  : Container for tables
-- Table     : Collection of rows & columns
-- Row       : Single record
-- Column    : Attribute of data
-- Primary Key : Unique identifier
-- Foreign Key : Link between tables
-- Schema    : Logical grouping of tables


-- ============================================================
-- 3. DATABASE COMMANDS
-- ============================================================

-- Create Database
CREATE DATABASE society_db;

-- Connect Database (run in psql)
-- \c society_db

-- List Databases
-- \l

-- Delete Database
-- DROP DATABASE society_db;



-- ============================================================
-- 4. TABLE COMMANDS
-- ============================================================

-- Create Table
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    age INT,
    email TEXT UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Show Tables
-- \dt

-- Describe Table
-- \d students

-- Delete Table
-- DROP TABLE students;



-- ============================================================
-- 5. INSERT COMMANDS
-- ============================================================

-- Insert Single Row
INSERT INTO students (name, age, email)
VALUES ('Amit', 20, 'amit@gmail.com');

-- Insert Multiple Rows
INSERT INTO students (name, age)
VALUES 
('Neha', 21),
('Kiran', 22);



-- ============================================================
-- 6. SELECT COMMANDS
-- ============================================================

-- Select All Data
SELECT * FROM students;

-- Select Specific Columns
SELECT name, age FROM students;

-- Select With Condition
SELECT * FROM students
WHERE age > 20;

-- Order Data
SELECT * FROM students
ORDER BY age DESC;

-- Limit Rows
SELECT * FROM students
LIMIT 5;



-- ============================================================
-- 7. UPDATE COMMAND
-- ============================================================

UPDATE students
SET age = 23
WHERE id = 1;



-- ============================================================
-- 8. DELETE COMMAND
-- ============================================================

DELETE FROM students
WHERE id = 2;



-- ============================================================
-- 9. CONSTRAINTS
-- ============================================================

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    age INT CHECK (age >= 18),
    country TEXT DEFAULT 'India'
);



-- ============================================================
-- 10. FOREIGN KEY EXAMPLE
-- ============================================================

CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    course_name TEXT
);

CREATE TABLE enrollments (
    id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(id),
    course_id INT REFERENCES courses(id)
);



-- ============================================================
-- 11. JOINS
-- ============================================================

-- INNER JOIN
SELECT students.name, courses.course_name
FROM enrollments
INNER JOIN students ON enrollments.student_id = students.id
INNER JOIN courses ON enrollments.course_id = courses.id;

-- LEFT JOIN
SELECT students.name, courses.course_name
FROM students
LEFT JOIN enrollments ON students.id = enrollments.student_id
LEFT JOIN courses ON enrollments.course_id = courses.id;



-- ============================================================
-- 12. INDEXES
-- ============================================================

CREATE INDEX idx_student_name
ON students(name);



-- ============================================================
-- 13. TRANSACTIONS
-- ============================================================

BEGIN;

UPDATE students SET age = age + 1 WHERE id = 1;

COMMIT;

-- If error happens
-- ROLLBACK;



-- ============================================================
-- 14. VIEWS
-- ============================================================

CREATE VIEW adult_students AS
SELECT * FROM students
WHERE age >= 18;