SELECT 
  jpf.job_id,
  cd.company_id,
  jpf.job_title_short as jobs,
  cd.name
FROM job_postings_fact AS jpf
INNER JOIN company_dim AS cd 
    ON jpf.company_id = cd.company_id;    


