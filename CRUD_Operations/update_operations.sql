/* ================================================================
   FILE: 03_update_operations.sql
   PURPOSE: PostgreSQL UPDATE Operations (CRUD - UPDATE Part)
   AUTHOR: Your Name
   PROJECT USE: PostgreSQL Study Repo + AI Research Data Management System
================================================================ */


/* ================================================================
   1. WHAT IS UPDATE IN CRUD?
================================================================ */
-- UPDATE modifies existing records in a table.
-- It is used to change values based on conditions.

-- IMPORTANT RULE:
-- ALWAYS use WHERE clause unless updating entire table.



/* ================================================================
   2. BASIC UPDATE COMMAND
================================================================ */

-- Update researcher institution
UPDATE research.researchers
SET institution = 'Advanced AI Lab'
WHERE researcher_id = 1;



/* ================================================================
   3. UPDATE MULTIPLE COLUMNS
================================================================ */

UPDATE research.researchers
SET
    institution = 'Global AI Lab',
    joined_date = CURRENT_DATE
WHERE researcher_id = 2;



/* ================================================================
   4. UPDATE ALL ROWS (USE CAREFULLY)
================================================================ */

-- Example: Increase accuracy by 1 for all models
UPDATE research.models
SET accuracy = accuracy + 1;



/* ================================================================
   5. UPDATE WITH CONDITION
================================================================ */

-- Update models with low accuracy
UPDATE research.models
SET accuracy = 75
WHERE accuracy < 50;



/* ================================================================
   6. UPDATE USING BETWEEN / IN
================================================================ */

UPDATE research.datasets
SET size_mb = size_mb + 50
WHERE dataset_id BETWEEN 1 AND 5;

UPDATE research.researchers
SET institution = 'Updated Institute'
WHERE researcher_id IN (3, 4);



/* ================================================================
   7. UPDATE USING SUBQUERY
================================================================ */

-- Update models created by specific researcher
UPDATE research.models
SET algorithm = 'Improved Algorithm'
WHERE created_by IN (
    SELECT researcher_id
    FROM research.researchers
    WHERE institution = 'Engineering College'
);



/* ================================================================
   8. UPDATE WITH JOIN
================================================================ */

-- PostgreSQL uses FROM for join update
UPDATE research.models m
SET algorithm = 'Deep Learning'
FROM research.researchers r
WHERE m.created_by = r.researcher_id
AND r.full_name = 'Sanjay Lade';



/* ================================================================
   9. UPDATE USING CASE STATEMENT
================================================================ */

UPDATE research.models
SET accuracy =
CASE
    WHEN accuracy >= 90 THEN accuracy
    WHEN accuracy >= 75 THEN accuracy + 5
    ELSE accuracy + 10
END;



/* ================================================================
   10. UPDATE NULL VALUES
================================================================ */

UPDATE research.datasets
SET description = 'No description provided'
WHERE description IS NULL;



/* ================================================================
   11. UPDATE WITH RETURNING
================================================================ */

-- Show updated rows
UPDATE research.researchers
SET institution = 'AI Excellence Center'
WHERE researcher_id = 1
RETURNING *;



/* ================================================================
   12. UPDATE INSIDE TRANSACTION (SAFE METHOD)
================================================================ */

BEGIN;

UPDATE research.models
SET accuracy = accuracy + 2
WHERE model_id = 1;

-- Check result
SELECT * FROM research.models WHERE model_id = 1;

-- If correct
COMMIT;

-- If mistake
-- ROLLBACK;



/* ================================================================
   13. REAL PROJECT EXAMPLES
================================================================ */

-- Example 1: Update experiment notes
UPDATE research.experiments
SET experiment_notes = 'Re-run with new hyperparameters'
WHERE experiment_id = 2;

-- Example 2: Update result metric
UPDATE research.results
SET metric_value = 0.95
WHERE metric_name = 'F1 Score';

-- Example 3: Correct researcher email
UPDATE research.researchers
SET email = 'sanjay.updated@college.edu'
WHERE email = 'sanjay@college.edu';
