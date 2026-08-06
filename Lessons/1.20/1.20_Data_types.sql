
DESCRIBE
SELECT 
   CAST( job_id AS VARCHAR) || '-' || CAST(company_id AS VARCHAR) AS job_company_id,
    CAST(job_work_from_home AS INT),
    CAST(job_posted_date AS DATE),
    CAST(salary_year_avg AS DECIMAL(10,0))
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

--------------------------OR-----------------------------------

SELECT 
    job_id :: VARCHAR|| '-' || company_id :: VARCHAR AS job_company_id,
    job_work_from_home :: INT,
    job_posted_date :: DATE,
    salary_year_avg :: DECIMAL(10,0)
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;
