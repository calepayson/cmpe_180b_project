-- Search by Surface
-- Version: 05
-- Memory Use: 634.78 MB
-- Notes: Stop searching recursively. Computes direct and first-order-indirect dependencies.

SELECT
  d.project_id,
  d.dependency_project_id,
  SUM(counts.dependent_projects_count) AS dependency_count
FROM 
  `bigquery-public-data.libraries_io.dependencies` AS d
JOIN (
  SELECT
    id,
    dependent_projects_count
  FROM
    `bigquery-public-data.libraries_io.projects`
) AS counts ON counts.id = d.project_i
JOIN (
  SELECT
    id,
    dependent_projects_count
  FROM
    `bigquery-public-data.libraries_io.projects`
) AS dependency_counts ON dependency_counts.id = d.dependency_project_id
GROUP BY
  d.project_id,
  d.dependency_project_id
ORDER BY
  dependency_count DESC
LIMIT
  50;
