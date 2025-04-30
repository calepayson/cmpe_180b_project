/*
 * Search by Project
 * Version: Final
 * Duration: 1 sec
 * Bytes Processed: 391.91 MB
 * Reads: 77,456,222
 * Writes: 14,010
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
      d.project_id AS dependency_project_id
  FROM  bigquery-public-data.libraries_io.dependencies AS d
  WHERE d.project_id = 2631407         

  UNION ALL

  -- depth-N  : dependents-of-dependents
  SELECT
      dt.depth + 1,
      d.dependency_project_id
  FROM  dep_tree AS dt
  JOIN  bigquery-public-data.libraries_io.dependencies AS d
        ON d.project_id = dt.dependency_project_id
  WHERE dt.depth < 2                              
)

SELECT
    COUNT(DISTINCT dependency_project_id)     AS total_dependencies,
    ARRAY_AGG(DISTINCT dependency_project_id IGNORE NULLS) AS dependency_project_ids
FROM dep_tree;
