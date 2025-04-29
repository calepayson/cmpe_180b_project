-- Search by Project
-- Version: 01
-- Memory Use: 4.95 GB
-- Notes: Return the project ids of all dependencies for a specified project.

DECLARE project_name STRING DEFAULT 'typescript';

SELECT
  d.dependency_project_id
FROM
  `bigquery-public-data.libraries_io.dependencies` as d
WHERE
  d.project_id IN (
    SELECT
      p.id
    FROM 
      `bigquery-public-data.libraries_io.projects` as p
    WHERE
      project_name = p.name
  );
