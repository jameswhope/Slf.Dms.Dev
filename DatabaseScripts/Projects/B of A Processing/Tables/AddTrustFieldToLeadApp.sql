﻿IF NOT EXISTS  (SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'tblLeadApplicant' 
AND COLUMN_NAME = 'LSATrustID')
	BEGIN
		ALTER TABLE tblLeadApplicant ADD LSATrustID INT
	END