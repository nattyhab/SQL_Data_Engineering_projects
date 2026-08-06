------------EXTRACT-

SELECT 
    EXTRACT(year FROM job_posted_date) AS job_posted_year,
    EXTRACT(month FROM job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer'
GROUP BY 
     EXTRACT(year FROM job_posted_date),
     EXTRACT(month FROM job_posted_date)
ORDER BY job_posted_year,
    job_posted_month
LIMIT 10;

----------------TRUNCATE----

SELECT 
    DATE_TRUNC('month', job_posted_date) AS job_posted_month,
    COUNT (job_id)
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer' AND 
    EXTRACT(year FROM job_posted_date) = 2024
GROUP BY DATE_TRUNC('month', job_posted_date)
ORDER BY job_posted_month;

-----------AT TIME ZONE_----------

