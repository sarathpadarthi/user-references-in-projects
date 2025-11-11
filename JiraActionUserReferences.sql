WITH TargetProject AS (
    SELECT ID
    FROM project
    WHERE pkey in 'comma separated pkey here'
)
  
SELECT
author as UserReference
FROM jiraaction
INNER JOIN jiraissue
ON jiraaction.issueid = jiraissue.id
INNER JOIN project
ON jiraissue.project = project.id
WHERE PROJECT in (SELECT ID FROM TargetProject)

UNION

SELECT
updateauthor as UserReference
FROM jiraaction
INNER JOIN jiraissue
ON jiraaction.issueid = jiraissue.id
INNER JOIN project
ON jiraissue.project = project.id
WHERE PROJECT in (SELECT ID FROM TargetProject);
