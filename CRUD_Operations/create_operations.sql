/* ================================================================
   FILE: 01_create_operations.sql
   PURPOSE: PostgreSQL CREATE Operations (CRUD - CREATE Part)
   AUTHOR: Your Name
   PROJECT USE: PostgreSQL Study Repo + AI Research Data Management System
   SAFE TO RUN MULTIPLE TIMES (Uses IF NOT EXISTS)
================================================================ */


/* ================================================================
   1. WHAT IS CREATE IN CRUD?
================================================================ */
-- CREATE means adding new objects or records into database.
-- It includes:
--   CREATE DATABASE
--   CREATE SCHEMA
--   CREATE TABLE
--   CREATE INDEX
--   CREATE VIEW
--   CREATE SEQUENCE


/* ================================================================
   2. CREATE DATABASE
================================================================ */

-- Create Database
CREATE DATABASE ai_research_db;

-- NOTE: After creating database, connect using psql:
-- \c ai_research_db



/* ================================================================
   3. CREATE SCHEMA
================================================================ */

-- Schemas organize tables logically
CREATE SCHEMA IF NOT EXISTS research;
CREATE SCHEMA IF NOT EXISTS admin;



/* ================================================================
   4. CREATE TABLES (AI RESEARCH DATA MANAGEMENT SYSTEM)
================================================================ */

-- ================================
-- TABLE: researchers
-- ================================
CREATE TABLE IF NOT EXISTS research.researchers (
    researcher_id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    institution TEXT,
    joined_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ================================
-- TABLE: datasets
-- ================================
CREATE TABLE IF NOT EXISTS research.datasets (
    dataset_id SERIAL PRIMARY KEY,
    dataset_name TEXT NOT NULL,
    description TEXT,
    size_mb INT CHECK (size_mb >= 0),
    uploaded_by INT REFERENCES research.researchers(researcher_id),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ================================
-- TABLE: models
-- ================================
CREATE TABLE IF NOT EXISTS research.models (
    model_id SERIAL PRIMARY KEY,
    model_name TEXT NOT NULL,
    algorithm TEXT,
    accuracy NUMERIC(5,2),
    created_by INT REFERENCES research.researchers(researcher_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ================================
-- TABLE: experiments
-- ================================
CREATE TABLE IF NOT EXISTS research.experiments (
    experiment_id SERIAL PRIMARY KEY,
    model_id INT REFERENCES research.models(model_id),
    dataset_id INT REFERENCES research.datasets(dataset_id),
    experiment_notes TEXT,
    experiment_date DATE DEFAULT CURRENT_DATE
);


-- ================================
-- TABLE: results
-- ================================
CREATE TABLE IF NOT EXISTS research.results (
    result_id SERIAL PRIMARY KEY,
    experiment_id INT REFERENCES research.experiments(experiment_id),
    metric_name TEXT,
    metric_value NUMERIC(10,4),
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



/* ================================================================
   5. CONSTRAINTS EXAMPLES
================================================================ */

-- Example of CHECK + DEFAULT + UNIQUE
CREATE TABLE IF NOT EXISTS admin.system_users (
    user_id SERIAL PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role TEXT DEFAULT 'user',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



/* ================================================================
   6. CREATE INDEX (IMPORTANT FOR PERFORMANCE)
================================================================ */

-- Index on researcher email
CREATE INDEX IF NOT EXISTS idx_researcher_email
ON research.researchers(email);

-- Index on dataset name
CREATE INDEX IF NOT EXISTS idx_dataset_name
ON research.datasets(dataset_name);

-- Index on model name
CREATE INDEX IF NOT EXISTS idx_model_name
ON research.models(model_name);



/* ================================================================
   7. CREATE VIEW (VIRTUAL TABLE)
================================================================ */

-- View showing model performance summary
CREATE OR REPLACE VIEW research.model_summary AS
SELECT
    m.model_name,
    m.algorithm,
    m.accuracy,
    r.full_name AS researcher
FROM research.models m
JOIN research.researchers r
ON m.created_by = r.researcher_id;



/* ================================================================
   8. CREATE SEQUENCE (ADVANCED AUTO-INCREMENT)
================================================================ */

CREATE SEQUENCE IF NOT EXISTS admin.ticket_seq
START 1000
INCREMENT 1;

-- Example usage:
-- SELECT nextval('admin.ticket_seq');



/* ================================================================
   9. BEST PRACTICES FOR CREATE COMMANDS
================================================================ */

-- 1. Always use PRIMARY KEY
-- 2. Use NOT NULL for important columns
-- 3. Use FOREIGN KEYS for relationships
-- 4. Use CHECK constraints for validation
-- 5. Use INDEX on frequently searched columns
-- 6. Use SCHEMA for organization
-- 7. Use TIMESTAMP for tracking records



/* ================================================================
   10. TEST DATA (OPTIONAL)
================================================================ */

INSERT INTO research.researchers (full_name, email, institution)
VALUES
('Sanjay Lade', 'sanjay@college.edu', 'Engineering College'),
('Priya Sharma', 'priya@ai-lab.com', 'AI Research Lab');



/* ================================================================
   END OF CREATE OPERATIONS FILE
================================================================ */