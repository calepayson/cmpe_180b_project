-- Search by Surface
-- Version: 08
-- Memory Use: 82.96 MB
-- Notes: Return only projects with first order dependencies within the desired range.

DECLARE min_deps INT64 DEFAULT 15000;
DECLARE max_deps INT64 DEFAULT 30000;

SELECT
  p.id AS project_id,
  COUNT(d.project_id) AS dependency_count
FROM
  `bigquery-public-data.libraries_io.projects` AS p
JOIN `bigquery-public-data.libraries_io.dependencies` AS d ON p.id = d.dependency_project_id
GROUP BY
  project_id
HAVING
  dependency_count BETWEEN min_deps AND max_deps
ORDER BY 
  dependency_count DESC
LIMIT 50;
