WITH TargetProject AS (
    SELECT ID
    FROM project
    WHERE pkey in 'comma separated pkey here'
)
  
SELECT
DISTINCT stringvalue as UserReference
FROM customfieldvalue
INNER JOIN jiraissue
ON customfieldvalue.issue = jiraissue.id
INNER JOIN project
on jiraissue.project = project.id
WHERE PROJECT in (SELECT ID FROM TargetProject);
