----COUNT ROWS - Aggregation only



-------PARTITION BY--- find hourly salary

SELECT 
    job_title_short,
    job_id,
    AVG(salary_hour_avg) OVER (PARTITION BY job_title_short,job_title_short)
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY RANDOM()
LIMIT 20;


-------------ORDER BY -------Ranking hourly salary

SELECT 
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(ORDER BY salary_hour_avg DESC)
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY salary_hour_avg DESC
LIMIT 20;
