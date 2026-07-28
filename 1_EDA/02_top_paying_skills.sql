-- 2. What are the highest paying skills for Data Engineers?


SELECT 
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg)) AS median_salary,
    COUNT(jpf.*) AS demand_count
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd 
    ON sjd.skill_id = sd.skill_id
    WHERE jpf.job_title_short = 'Data Engineer'
        AND jpf.job_work_from_home = TRUE
        AND jpf.salary_year_avg IS NOT NULL
GROUP BY sd.skills
HAVING COUNT(jpf.*) >100
ORDER BY median_salary DESC
LIMIT 25;

/*
────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ terraform  │      184000.0 │          193 │
│ kubernetes │      150500.0 │          147 │
│ airflow    │      150000.0 │          386 │
│ kafka      │      145000.0 │          292 │
│ pyspark    │      140000.0 │          152 │
│ spark      │      140000.0 │          503 │
│ git        │      140000.0 │          208 │
│ go         │      140000.0 │          113 │
│ aws        │      137320.0 │          783 │
│ scala      │      137290.0 │          247 │
│ gcp        │      136000.0 │          196 │
│ mongodb    │      135750.0 │          136 │
│ snowflake  │      135500.0 │          438 │
│ bigquery   │      135000.0 │          123 │
│ docker     │      135000.0 │          144 │
│ github     │      135000.0 │          127 │
│ python     │      135000.0 │         1133 │
│ java       │      135000.0 │          303 │
│ hadoop     │      135000.0 │          198 │
│ r          │      134775.0 │          133 │
│ nosql      │      134415.0 │          193 │
│ databricks │      132750.0 │          266 │
│ mysql      │      130500.0 │          101 │
│ redshift   │      130000.0 │          274 │
│ sql        │      130000.0 │         1128 │
└────────────┴───────────────┴──────────────┘
  25 rows                         3 columns
*/