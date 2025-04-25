-- Search by Surface
-- Version: 01
-- Memory Use: 509.7 MB
-- Notes: Returns a list of projects sorted by the number of direct dependencies.
SELECT 
  p.name AS project_name,
  COUNT(d.project_id) AS dependency_count
FROM 
  `bigquery-public-data.libraries_io.projects` AS p
JOIN
  `bigquery-public-data.libraries_io.dependencies` AS d
  ON p.id = d.dependency_project_id
GROUP BY 
  project_id, 
  project_name
ORDER BY 
  dependency_count DESC
LIMIT 50;
