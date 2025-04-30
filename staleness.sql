/*
 * Staleness
 * Version: Final
 * Duration: 0 sec
 * Bytes Processed: 1.8 GB
 * Reads: 21,189,977
 * Writes: 54,000
 * 
 * Description:
 *   Builds a table of stale tags (older than N months).
 *   Joins stale tags with the repository_dependencies table.
 *   Returns repositories pinned to stale tags.
 */

WITH stale_tags AS (
  SELECT
    repository_id,
    tag_name,
    tag_git_sha,
    tag_published_timestamp,
    tag_created_timestamp
  FROM
    `bigquery-public-data.libraries_io.tags`
  WHERE
    tag_published_timestamp IS NOT NULL
    AND DATE(tag_published_timestamp) < DATE_SUB(CURRENT_DATE(), INTERVAL 12
    MONTH)
  LIMIT 1000
)

SELECT
  rd.repository_id, -- repo using the dependency
  rd.manifest_platform,
  rd.manifest_filepath,
  rd.dependency_project_id, -- the project being depended on
  rd.dependency_project_name,
  rd.dependency_requirements AS pinned_tag_name,
  st.tag_published_timestamp,
  st.tag_created_timestamp
FROM
  `bigquery-public-data.libraries_io.repository_dependencies` rd
JOIN
  stale_tags st
ON
  rd.dependency_requirements = st.tag_name
ORDER BY
  st.tag_published_timestamp ASC
LIMIT 1000;
