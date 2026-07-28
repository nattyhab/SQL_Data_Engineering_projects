-- What are the most optimal skills for data engineers balancing both demand and salary?
SELECT 
    sd.skills,
    COUNT(jpf.*) AS demand_count,
    ROUND(MEDIAN(jpf.salary_year_avg)) AS median_salary,
   ROUND( LN(demand_count*median_salary),1) AS  LN_optimal
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY sd.skills
HAVING  COUNT(jpf.*) > 100
ORDER BY 
 demand_count DESC,
 median_salary DESC
LIMIT 10;

/*
┌───────────┬──────────────┬───────────────┬────────────┐
│  skills   │ demand_count │ median_salary │ LN_optimal │
│  varchar  │    int64     │    double     │   double   │
├───────────┼──────────────┼───────────────┼────────────┤
│ python    │         1133 │      135000.0 │       18.8 │
│ sql       │         1128 │      130000.0 │       18.8 │
│ aws       │          783 │      137320.0 │       18.5 │
│ spark     │          503 │      140000.0 │       18.1 │
│ azure     │          475 │      128000.0 │       17.9 │
│ snowflake │          438 │      135500.0 │       17.9 │
│ airflow   │          386 │      150000.0 │       17.9 │
│ java      │          303 │      135000.0 │       17.5 │
│ kafka     │          292 │      145000.0 │       17.6 │
│ redshift  │          274 │      130000.0 │       17.4 │
└───────────┴──────────────┴───────────────┴────────────┘
  10 rows                                     4 columns
*/