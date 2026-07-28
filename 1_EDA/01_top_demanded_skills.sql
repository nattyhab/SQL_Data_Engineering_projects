--Question: What are the most in-demand skills for data engineers?
SELECT 
    sd.skills
    COUNT(jpf.*) AS demand_count,
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd 
    ON sjd.skill_id = sd.skill_id
    WHERE jpf.job_title_short = 'Data Engineer'
        AND jpf.job_work_from_home = TRUE
GROUP BY sd.skills
ORDER BY demand_count DESC
LIMIT 10;

/*
┌──────────────┬────────────┐
│ demand_count │   skills   │
│    int64     │  varchar   │
├──────────────┼────────────┤
│        29221 │ sql        │
│        28776 │ python     │
│        17823 │ aws        │
│        14143 │ azure      │
│        12799 │ spark      │
│         9996 │ airflow    │
│         8639 │ snowflake  │
│         8183 │ databricks │
│         7267 │ java       │
│         6446 │ gcp        │
└──────────────┴────────────┘
  10 rows         2 columns
*/


