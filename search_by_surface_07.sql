-- Search by Surface
-- Version: 04
-- Memory Use: 871.08 MB
-- Notes: Return only repositories with a dependency count in the desired range.

DECLARE min_deps INT64 DEFAULT 500;
DECLARE max_deps INT64 DEFAULT 1000;

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
HAVING
  dependency_count BETWEEN min_deps AND max_deps
ORDER BY
  dependency_count DESC
LIMIT
  50;
