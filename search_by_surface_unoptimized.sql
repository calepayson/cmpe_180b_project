/*
 * Search by Surface
 * Version: Unoptimized
 * Bytes Processed: 2.75 GB
 * Duration: 8 min 4 sec
 * Reads: 73,451,924,317
 * Writes: 930,594,688
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
    *
  FROM
    `bigquery-public-data.libraries_io.dependencies` AS d
),

-- Find second-order dependents
deps_level2 AS (
  SELECT
    d2.*
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
  d.*,
  ad.*,
  COUNT(*) OVER() AS row_count,
  COUNT(DISTINCT ad.project_id) AS total_dependencies
FROM
  all_dependencies AS ad
JOIN
  `bigquery-public-data.libraries_io.dependencies` AS d
  ON ad.dependency_project_id = d.project_id
GROUP BY
  d.id, d.platform, d.project_name, d.project_id, d.version_number, d.version_id, d.dependency_name, d.dependency_platform, d.dependency_kind, d.optional_dependency, d.dependency_requirements, d.dependency_project_id,
  ad.id, ad.platform, ad.project_name, ad.project_id, ad.version_number, ad.version_id, ad.dependency_name, ad.dependency_platform, ad.dependency_kind, ad.optional_dependency, ad.dependency_requirements, ad.dependency_project_id
HAVING 
  total_dependencies BETWEEN min_deps AND max_deps
ORDER BY
  total_dependencies DESC
LIMIT 50;
