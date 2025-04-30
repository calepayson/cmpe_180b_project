/*
 * Single Point of Failure
 * Version: Final
 * Bytes Processed: 1.15 GB
 * Duration: 1 sec
 * Reads: 32,437,163
 * Writes: 67,758
 *
 * Description:
 *   Joins the repository and project tables.
 *   Filters the resulting table to only include repos with 100+ downstream
 *   dependencide and <= 1 active maintainers.
 */

SELECT
  r.id AS repository_id,
  r.name_with_owner AS repo_full_name,
  r.contributors_count,
  p.name AS project_name,
  p.platform,
  p.dependent_repositories_count AS downstream_repos
FROM
  `bigquery-public-data.libraries_io.projects` AS p
JOIN
  `bigquery-public-data.libraries_io.repositories` AS r
  ON p.repository_id = r.id -- link project → its hosting repo
WHERE
  p.dependent_repositories_count >= 100 -- 100+ downstream repos
  AND COALESCE(r.contributors_count,0) <= 1 -- 0-or-1 maintainers
ORDER BY
  downstream_repos DESC;
