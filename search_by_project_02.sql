-- Search by Project
-- Version: 02
-- Memory Use: 5.07 GB
-- Notes: Return the project ids of all second-order dependencies for a specified project.

DECLARE project_name STRING DEFAULT 'typescript';

SELECT
  d.dependency_project_id
FROM
  `bigquery-public-data.libraries_io.dependencies` as d
WHERE 
  d.project_id IN (
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
      )
  );
