/*DESCRIBE
SELECT 

┌──────────────────────────────────────────────────────────────────────────────────────┐
│                                       Describe                                       │
│                                                                                      │
│ job_id                integer   not null    company_id            integer            │
│ job_title_short       varchar               job_title             varchar            │
│ job_location          varchar               job_via               varchar            │
│ job_schedule_type     varchar               job_work_from_home    boolean            │
│ search_location       varchar               job_posted_date       timestamp          │
│ job_no_degree_mention boolean               job_health_insurance  boolean            │
│ job_country           varchar               salary_rate           varchar            │
│ salary_year_avg       double                salary_hour_avg       double             │
│ company_id            integer   not null    name                  varchar            │
│ link                  varchar               link_google           varchar            │
│ thumbnail             varchar                                                        │
└──────────────────────────────────────────────────────────────────────────────────────┘
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd 
    ON jpf.company_id = cd.company_id
LIMIT 10 ;
*/
--------------------CTAS------------------------

CREATE OR REPLACE TABLE staging.job_posting_flat AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id;

SELECT * 
FROM staging.job_posting_flat;

-------------------------VIEW-----------------------------

CREATE OR REPLACE VIEW staging.job_posting_flat_view AS

SELECT 
    jpf.*
FROM staging.job_posting_flat AS jpf
LEFT JOIN staging.priority_roles AS pr
    ON jpf.job_title_short = pr.role_name
WHERE priority_lvl = 1;

SELECT 
    job_title_short,
    COUNT(*) AS job_count
FROM staging.job_posting_flat_view
GROUP BY job_title_short 
ORDER BY job_count DESC;

---------------------------TEMPORARY TABLE _-----------------------------------
CREATE TEMPORARY TABLE Senior_jobs_flat_temp AS 
SELECT *
FROM staging.job_posting_flat_view
WHERE job_title_short = 'Senior Data Engineer';

SELECT 
    job_title_short,
    COUNT(*) AS job_count
FROM Senior_jobs_flat_temp
GROUP BY job_title_short 
ORDER BY job_count DESC;


------------------------DELETE------------------

DELETE FROM staging.job_posting_flat
WHERE job_posted_date < '2024-01-01';

-----------------check-------------------
SELECT 
    COUNT(*)
FROM staging.job_posting_flat;

SELECT
    COUNT(*)
FROM staging.job_posting_flat_view;

----------------TRUNCATE----------------------

TRUNCATE TABLE staging.job_posting_flat;

------------check----------------------
SELECT 
   COUNT(*)
FROM staging.job_posting_flat;

-----------insert values to table ----------

INSERT INTO staging.job_posting_flat

SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE job_posted_date > '2024-01-01' ;


