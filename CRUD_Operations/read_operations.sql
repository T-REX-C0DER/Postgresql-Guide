/* ================================================================
   FILE: 02_read_operations.sql
   PURPOSE: PostgreSQL READ Operations (CRUD - READ Part)
   AUTHOR: Your Name
   PROJECT USE: PostgreSQL Study Repo + AI Research Data Management System
================================================================ */


/* ================================================================
   1. WHAT IS READ IN CRUD?
================================================================ */
-- READ means retrieving data from database.
-- It is done using SELECT statements.
-- READ includes filtering, sorting, joins, aggregation, etc.



/* ================================================================
   2. BASIC SELECT COMMANDS
================================================================ */

-- Select all columns
SELECT * FROM research.researchers;

-- Select specific columns
SELECT full_name, email FROM research.researchers;

-- Select unique values
SELECT DISTINCT institution FROM research.researchers;



/* ================================================================
   3. FILTERING DATA (WHERE CLAUSE)
================================================================ */

-- Find researchers from specific institution
SELECT * FROM research.researchers
WHERE institution = 'AI Research Lab';

-- Using AND / OR
SELECT * FROM research.models
WHERE accuracy > 90 AND algorithm = 'Random Forest';

-- Using BETWEEN
SELECT * FROM research.datasets
WHERE size_mb BETWEEN 100 AND 1000;

-- Using IN
SELECT * FROM research.researchers
WHERE institution IN ('AI Research Lab', 'Engineering College');

-- Using LIKE
SELECT * FROM research.researchers
WHERE full_name LIKE 'S%';



/* ================================================================
   4. SORTING DATA
================================================================ */

-- Sort ascending
SELECT * FROM research.models
ORDER BY accuracy ASC;

-- Sort descending
SELECT * FROM research.models
ORDER BY accuracy DESC;

-- Sort by multiple columns
SELECT * FROM research.datasets
ORDER BY size_mb DESC, dataset_name ASC;



/* ================================================================
   5. LIMIT & OFFSET (PAGINATION)
================================================================ */

-- Get first 5 rows
SELECT * FROM research.researchers
LIMIT 5;

-- Skip first 5 rows
SELECT * FROM research.researchers
OFFSET 5;



/* ================================================================
   6. AGGREGATE FUNCTIONS
================================================================ */

-- Count researchers
SELECT COUNT(*) FROM research.researchers;

-- Average model accuracy
SELECT AVG(accuracy) FROM research.models;

-- Maximum dataset size
SELECT MAX(size_mb) FROM research.datasets;

-- Group By institution
SELECT institution, COUNT(*) AS total_researchers
FROM research.researchers
GROUP BY institution;

-- Having clause
SELECT algorithm, AVG(accuracy) AS avg_accuracy
FROM research.models
GROUP BY algorithm
HAVING AVG(accuracy) > 80;



/* ================================================================
   7. JOINS (IMPORTANT FOR PROJECTS)
================================================================ */

-- INNER JOIN
SELECT
    m.model_name,
    m.algorithm,
    r.full_name AS researcher
FROM research.models m
INNER JOIN research.researchers r
ON m.created_by = r.researcher_id;


-- LEFT JOIN
SELECT
    d.dataset_name,
    r.full_name
FROM research.datasets d
LEFT JOIN research.researchers r
ON d.uploaded_by = r.researcher_id;


-- MULTIPLE JOIN
SELECT
    e.experiment_id,
    m.model_name,
    d.dataset_name
FROM research.experiments e
JOIN research.models m ON e.model_id = m.model_id
JOIN research.datasets d ON e.dataset_id = d.dataset_id;



/* ================================================================
   8. SUBQUERIES
================================================================ */

-- Find researchers who created models above avg accuracy
SELECT full_name
FROM research.researchers
WHERE researcher_id IN (
    SELECT created_by
    FROM research.models
    WHERE accuracy > (
        SELECT AVG(accuracy) FROM research.models
    )
);



/* ================================================================
   9. EXISTS CLAUSE
================================================================ */

SELECT full_name
FROM research.researchers r
WHERE EXISTS (
    SELECT 1
    FROM research.models m
    WHERE m.created_by = r.researcher_id
);



/* ================================================================
   10. ALIASING
================================================================ */

SELECT
    m.model_name AS Model,
    m.accuracy AS Accuracy
FROM research.models m;



/* ================================================================
   11. VIEW QUERY
================================================================ */

-- Read from view
SELECT * FROM research.model_summary;



/* ================================================================
   12. CASE STATEMENT
================================================================ */

SELECT
    model_name,
    CASE
        WHEN accuracy >= 90 THEN 'Excellent'
        WHEN accuracy >= 75 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS performance
FROM research.models;



/* ================================================================
   13. JSON QUERY (ADVANCED FEATURE)
================================================================ */

-- Example JSON column query
-- Assume column experiment_notes_json JSONB exists
-- SELECT experiment_notes_json->>'note' FROM research.experiments;



/* ================================================================
   14. BEST PRACTICES FOR READ QUERIES
================================================================ */

-- 1. Avoid SELECT * in production
-- 2. Use indexes for faster search
-- 3. Use LIMIT when testing large tables
-- 4. Use proper JOIN instead of nested queries
-- 5. Always filter large datasets
-- 6. Use EXPLAIN ANALYZE for optimization



/* ================================================================
   15. TEST QUERIES FOR PRACTICE
================================================================ */

-- Show top 3 best models
SELECT model_name, accuracy
FROM research.models
ORDER BY accuracy DESC
LIMIT 3;

-- Show datasets uploaded by each researcher
SELECT r.full_name, COUNT(d.dataset_id) AS total_datasets
FROM research.researchers r
LEFT JOIN research.datasets d
ON r.researcher_id = d.uploaded_by
GROUP BY r.full_name;
