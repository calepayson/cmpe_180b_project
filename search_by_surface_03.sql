-- Search by Surface
-- Version: 03
-- Memory Use: 871.08 MB
-- Notes: Recursively search dependencies to account for indirect dependencies.
WITH RECURSIVE all_dependencies AS (
  -- Base case: direct dependencies
  SELECT
    d.project_id,
    d.dependency_project_id,
    1 AS depth
  FROM
    `bigquery-public-data.libraries_io.dependencies` AS d

  UNION ALL

  -- Recursive case: dependencies of dependencies
  SELECT
    ad.project_id,
    d.dependency_project_id,
    ad.depth + 1
  FROM 
    all_dependencies AS ad
  JOIN 
    `bigquery-public-data.libraries_io.dependencies` AS d 
    ON ad.dependency_project_id = d.project_id
)

SELECT
  d.project_name AS project_name,
  COUNT(DISTINCT ad.project_id) AS total_dependencies
FROM
  all_dependencies AS ad
JOIN
  `bigquery-public-data.libraries_io.dependencies` AS d
  ON ad.dependency_project_id = d.project_id
GROUP BY
  project_name
ORDER BY
  total_dependencies DESC
LIMIT 50;
