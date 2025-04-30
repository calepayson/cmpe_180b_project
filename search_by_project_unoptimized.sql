/*
 * Search by Project
 * Version: Unoptimized
 * Duration: 4 sec
 * Bytes Processed: 2.75 GB
 * Reads: 77,438,796
 * Writes: 435
 * 
 * Description:
 *   Builds a tree of upstream dependents using the dependencies table.
 *   Counts the total number of upstream dependencies and returns the count and
 *   their id's.
 */

WITH RECURSIVE dep_tree AS (
  -- depth-1  : direct dependents of the target
  SELECT
      1 AS depth,
      d.*
  FROM  bigquery-public-data.libraries_io.dependencies AS d
  WHERE d.project_id = 2631407         

  UNION ALL

  -- depth-N  : dependents-of-dependents
  SELECT
      dt.depth + 1,
      d.*
  FROM  dep_tree AS dt
  JOIN  bigquery-public-data.libraries_io.dependencies AS d
        ON d.project_id = dt.dependency_project_id
  WHERE dt.depth < 3                              
)

SELECT
COUNT(*) AS row_count,
    COUNT(DISTINCT dependency_project_id)     AS total_dependencies,
    ARRAY_AGG(DISTINCT dependency_project_id IGNORE NULLS) AS dependency_project_ids,
    ARRAY_AGG(STRUCT(depth, id, platform, project_name, project_id, version_number, version_id, dependency_name, dependency_platform, dependency_kind, optional_dependency, dependency_requirements, dependency_project_id))
FROM dep_tree;
