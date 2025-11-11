WITH TargetProject AS (
    SELECT ID
    FROM project
    WHERE pkey in 'comma separated pkey here'
)
  
SELECT
DISTINCT source_name as UserReference
FROM userassociation
INNER JOIN jiraissue
ON userassociation.sink_node_id = jiraissue.id
INNER JOIN project
on jiraissue.project = project.id
WHERE PROJECT in (SELECT ID FROM TargetProject) and userassociation.association_type in ('VoteIssue','WatchIssue');
