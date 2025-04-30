SELECT 
    p.id AS project_id,
    p.name AS project_name,
    p.platform AS project_platform,
    p.created_timestamp,
    p.updated_timestamp,
    p.description AS project_description,
    p.keywords,
    p.homepage_url,
    p.repository_url,
    p.language,
    d.dependency_name,
    d.dependency_platform,
    d.dependency_kind,
    d.optional_dependency,
    d.dependency_requirements
FROM (
    SELECT *
    FROM `bigquery-public-data.libraries_io.projects`
    ORDER BY updated_timestamp DESC
    LIMIT 100
) p
JOIN `bigquery-public-data.libraries_io.dependencies` d
    ON p.id = d.project_id
ORDER BY p.updated_timestamp DESC, d.dependency_name;
