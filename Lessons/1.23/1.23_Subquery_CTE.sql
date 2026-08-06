-------------SUBQUERY----------------

SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL OR
    salary_hour_avg IS NOT NULL
)
LIMIT 10;

--------------------SUBQUERY IN SELECT------------------------------------
--Show each job next to the over all markert median:

SELECT
    job_title_short,
    (
    SELECT 
        MEDIAN(salary_year_avg) 
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
    ) AS market_median_salary,
    salary_year_avg 
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
--ORDER BY salary_year_avg DESC
LIMIT 10;
------------------SUBQUERY IN FROM----------------------
--Stage only jobs that are remote before aggregatnig:

SELECT
    job_title_short,
    median(salary_year_avg) AS median_salary,
    (
    SELECT 
        MEDIAN(salary_year_avg) 
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL AND 
        job_work_from_home = TRUE
    ) AS market_remot_median_salary,
    
     
FROM 
    ( SELECT *
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE 
    )
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short
--ORDER BY salary_year_avg DESC
LIMIT 10;

----------------SUBQUERY IN HAVING-----------------------

--Keep only job titles whose median salary is above the overall median:
SELECT
    job_title_short,
    median(salary_year_avg) AS median_salary,
    (
    SELECT 
        MEDIAN(salary_year_avg) 
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL AND 
        job_work_from_home = TRUE
    ) AS market_remot_median_salary
FROM 
    ( SELECT *
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE 
    )
WHERE salary_year_avg IS NOT NULL

GROUP BY job_title_short
HAVING median(salary_year_avg) > 
    (
    SELECT 
        MEDIAN(salary_year_avg) 
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL AND 
        job_work_from_home = TRUE
    ) 
    
--ORDER BY salary_year_avg DESC
LIMIT 10;


-----------------------CTEs-----------------------------

WITH valid_salaries AS(
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL OR
    salary_hour_avg IS NOT NULL)
    

SELECT *
FROM valid_salaries;
-----------------------------------------------------

-- compare how much more(less ) remote roles pay compared to onsite roles for each job title.
-- use CTE to calculate the median salary by title and work arrangement, then compare the medians
WITH title_median AS (
SELECT job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    job_work_from_home
FROM job_postings_fact
GROUP BY 
    job_title_short,
    job_work_from_home
)
SELECT r.job_title_short,
    r.median_salary AS remote_median_salary,
    o.median_salary AS onsite_median_salary,
    (r.median_salary- o.median_salary) AS remote_premium 
FROM title_median AS r
INNER JOIN title_median AS o ON
    r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE
    AND o.job_work_from_home = FALSE;

------------------------WHERE (NOT) EXISTS----------------------------------------

SELECT *
FROM range(3) AS src(key);

SELECT *
FROM range(2) AS tgt(key);

SELECT *
FROM range(3) AS src(key)
WHERE EXISTS
    (
    SELECT 1
FROM range(2) AS tgt(key)
WHERE src.key= tgt.key 
    );
---------------------------------------------------------
--- identify job postings that have no associated skills before loading them into a data mart
SELECT *
FROM job_postings_fact AS jpf
WHERE NOT EXISTS 
    (
        SELECT 1
        FROM skills_job_dim AS sjd
        WHERE sjd.job_id = jpf.job_id
    )
    ORDER BY job_id
LIMIT 10;