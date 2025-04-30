/*
 * Search by Surface
 * Version: Final
 * Bytes Processed: 391.91 MB
 * Duration: 11 sec
 * Reads: 214,814,174
 * Writes: 111,566,688
 * 
 * Description:
 *   Builds a tree of downstream dependents using the dependencies table.
 *   Counts the size of the dependency tree for each project.
 *   Returns a list of results that have a number of downstream dependents
 *   within the desired range.
 */

-- Adjust search range
DECLARE min_deps INT64 DEFAULT 50;
DECLARE max_deps INT64 DEFAULT 150;

-- Find direct dependents
WITH deps_level1 AS (
  SELECT
    d.project_id,
    d.dependency_project_id
  FROM
    `bigquery-public-data.libraries_io.dependencies` AS d
),

-- Find second-order dependents
deps_level2 AS (
  SELECT
    d1.project_id,
    d2.dependency_project_id
  FROM
    deps_level1 d1
  JOIN
    `bigquery-public-data.libraries_io.dependencies` AS d2
    ON d1.dependency_project_id = d2.project_id
),

-- Combine dependency_levels
all_dependencies AS (
  SELECT * FROM deps_level1
  UNION DISTINCT
  SELECT * FROM deps_level2
)

-- Look up projects with dependencies within the specified range
SELECT
  d.project_id AS project_id,
  COUNT(DISTINCT ad.project_id) AS total_dependencies
FROM
  all_dependencies AS ad
JOIN
  `bigquery-public-data.libraries_io.dependencies` AS d
  ON ad.dependency_project_id = d.project_id
GROUP BY
  project_id
HAVING 
  total_dependencies BETWEEN min_deps AND max_deps
ORDER BY
  total_dependencies DESC
LIMIT 50;
