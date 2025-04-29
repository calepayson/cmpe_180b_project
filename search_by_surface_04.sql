-- Search by Surface
-- Version: 04
-- Memory Use: 871.08 MB
-- Notes: Recursively search dependencies and only return results within the desired range. Limits depth.

DECLARE min_deps INT64 DEFAULT 50;
DECLARE max_deps INT64 DEFAULT 150;
DECLARE max_depth INT64 DEFAULT 5;

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
  WHERE ad.depth < max_depth;
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
HAVING 
  total_dependencies BETWEEN min_deps AND max_deps
ORDER BY
  total_dependencies DESC
LIMIT 50;
