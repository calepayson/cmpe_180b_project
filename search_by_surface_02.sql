-- Search by Surface
-- Version: 02
-- Memory Use: 509.7 MB
-- Notes: Uses sourcerank as a stand in for dependency count (sourcerank attempts to quantify quality of dependencies).
SELECT 
  p.name AS project_name,
  p.sourcerank AS sourcerank
FROM 
  `bigquery-public-data.libraries_io.projects` AS p
ORDER BY 
  sourcerank DESC
LIMIT 50;
