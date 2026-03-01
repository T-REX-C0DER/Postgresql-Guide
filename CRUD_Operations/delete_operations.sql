/* ================================================================
   FILE: 04_delete_operations.sql
   PURPOSE: PostgreSQL DELETE Operations (CRUD - DELETE Part)
   AUTHOR: Your Name
   PROJECT USE: PostgreSQL Study Repo + AI Research Data Management System
================================================================ */


/* ================================================================
   1. WHAT IS DELETE IN CRUD?
================================================================ */
-- DELETE removes records from a table.
-- It can delete specific rows or all rows.

-- IMPORTANT RULE:
-- ALWAYS use WHERE clause unless deleting all records intentionally.



/* ================================================================
   2. BASIC DELETE COMMAND
================================================================ */

-- Delete a researcher by ID
DELETE FROM research.researchers
WHERE researcher_id = 5;



/* ================================================================
   3. DELETE WITH CONDITION
================================================================ */

-- Delete models with very low accuracy
DELETE FROM research.models
WHERE accuracy < 40;

-- Delete datasets uploaded before specific date
DELETE FROM research.datasets
WHERE uploaded_at < '2024-01-01';



/* ================================================================
   4. DELETE MULTIPLE ROWS USING IN
================================================================ */

DELETE FROM research.researchers
WHERE researcher_id IN (10, 11, 12);



/* ================================================================
   5. DELETE USING SUBQUERY
================================================================ */

-- Delete experiments of deleted models
DELETE FROM research.experiments
WHERE model_id IN (
    SELECT model_id
    FROM research.models
    WHERE accuracy < 50
);



/* ================================================================
   6. DELETE USING USING (JOIN DELETE)
================================================================ */

-- PostgreSQL supports DELETE with USING clause
DELETE FROM research.models m
USING research.researchers r
WHERE m.created_by = r.researcher_id
AND r.institution = 'Old Institute';



/* ================================================================
   7. DELETE ALL ROWS (USE CAREFULLY)
================================================================ */

-- Deletes all rows but keeps table structure
DELETE FROM research.results;



/* ================================================================
   8. TRUNCATE TABLE
================================================================ */

-- Faster than DELETE but cannot rollback easily
TRUNCATE TABLE research.results;

-- Truncate multiple tables
TRUNCATE TABLE research.results, research.experiments;



/* ================================================================
   9. DELETE WITH RETURNING
================================================================ */

-- Show deleted rows
DELETE FROM research.researchers
WHERE researcher_id = 3
RETURNING *;



/* ================================================================
   10. DELETE WITH LIMIT (WORKAROUND)
================================================================ */

-- PostgreSQL does not support DELETE LIMIT directly
DELETE FROM research.datasets
WHERE dataset_id IN (
    SELECT dataset_id
    FROM research.datasets
    LIMIT 5
);



/* ================================================================
   11. DELETE INSIDE TRANSACTION (SAFE METHOD)
================================================================ */

BEGIN;

DELETE FROM research.models
WHERE model_id = 2;

-- Check before final delete
SELECT * FROM research.models WHERE model_id = 2;

-- If correct
COMMIT;

-- If mistake
-- ROLLBACK;



/* ================================================================
   12. FOREIGN KEY DELETE OPTIONS
================================================================ */

-- Example: Create table with CASCADE delete
CREATE TABLE IF NOT EXISTS research.test_parent (
    id SERIAL PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS research.test_child (
    id SERIAL PRIMARY KEY,
    parent_id INT REFERENCES research.test_parent(id)
    ON DELETE CASCADE
);

-- Now deleting parent deletes child automatically



/* ================================================================
   13. REAL PROJECT EXAMPLES
================================================================ */

-- Example 1: Remove duplicate datasets
DELETE FROM research.datasets
WHERE dataset_name = 'test_dataset';

-- Example 2: Delete failed experiments
DELETE FROM research.experiments
WHERE experiment_notes LIKE '%failed%';

-- Example 3: Remove inactive system users
DELETE FROM admin.system_users
WHERE is_active = FALSE;
