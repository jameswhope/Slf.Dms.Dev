
UPDATE tblCommStruct
SET ParentCommStructID = sub.[parent]
FROM 
(
	SELECT s.CommStructID [child], p.CommStructID [parent]
	FROM tblCommStruct s
	JOIN tblCommStruct p 
		ON p.CommScenId = s.CommScenID 
		AND p.CompanyID = s.CompanyID 
		AND p.CommRecID = s.ParentCommRecID
) sub
WHERE CommStructID = sub.[child] AND ParentCommStructID IS NULL
AND CompanyID = 5