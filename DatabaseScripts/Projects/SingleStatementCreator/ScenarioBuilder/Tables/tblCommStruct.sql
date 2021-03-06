
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('tblCommStruct') AND NAME = 'ParentCommStructID') 
	BEGIN
		ALTER TABLE tblCommStruct ADD [ParentCommStructID] [INT] NULL 
	END
GO

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