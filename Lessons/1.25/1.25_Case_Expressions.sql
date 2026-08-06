-- Bucket salary

SELECT

    job_title_short,
    salary_hour_avg,
    CASE
        WHEN salary_hour_avg < 25 THEN 'low'
        WHEN salary_hour_avg < 50 THEN 'medium'
        ELSE 'high'
    END AS salary_catagory
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
LIMIT 10;


WITH salary_cat AS (
    SELECT job_title_short,
        salary_hour_avg,
        salary_year_avg,
        CASE
            WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
            WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg*2080
            WHEN salary_hour_avg IS NULL AND salary_year_avg IS NULL THEN 'empty'
        END AS standard_salary
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL 

SELECT 
    *,
    CASE 
        WHEN standard_salary<75000 THEN 'low'
        WHEN standard_salary BETWEEN 75000 AND 100000 THEN 'medium'
        WHEN standard_salary>100000 THEN 'high'
        ELSE NULL
    END AS salary_catagory
FROM salary_cat
ORDER BY  salary_year_avg;

