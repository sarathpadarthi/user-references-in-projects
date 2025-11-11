WITH TargetProject AS (
    SELECT ID
    FROM project
    WHERE pkey in 'comman separated pkeys here'
)
SELECT 
reporter as UserReference
FROM jiraissue 
WHERE PROJECT in (SELECT ID FROM TargetProject)

UNION

SELECT 
assignee as UserReference
FROM jiraissue 
WHERE PROJECT in (SELECT ID FROM TargetProject)

UNION

SELECT 
creator as UserReference
FROM jiraissue 
WHERE PROJECT in (SELECT ID FROM TargetProject);
