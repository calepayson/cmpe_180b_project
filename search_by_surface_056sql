-- Search by Surface
-- Version: 05
-- Memory Use: 634.78 MB
-- Notes: Precomputes project_counts

WITH project_counts AS (
    SELECT
    id,
    dependent_projects_count
  FROM
    `bigquery-public-data.libraries_io.projects`
)

SELECT
  d.project_id,
  d.dependency_project_id,
  SUM(counts.dependent_projects_count) AS dependency_count
FROM 
  `bigquery-public-data.libraries_io.dependencies` AS d
JOIN
  project_counts AS counts ON counts.id = d.project_id
JOIN 
  project_counts AS dependency_counts ON dependency_counts.id = d.dependency_project_id
GROUP BY
  d.project_id,
  d.dependency_project_id
ORDER BY
  dependency_count DESC
LIMIT
  50;
