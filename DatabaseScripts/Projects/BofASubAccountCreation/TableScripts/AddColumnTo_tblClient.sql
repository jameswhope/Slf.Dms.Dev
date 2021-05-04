IF NOT EXISTS (SELECT * FROM syscolumns 
WHERE id=OBJECT_ID ('tblClient') 
AND NAME='BofAConversionDate')
BEGIN
	ALTER TABLE tblClient ADD BofAConversionDate DATETIME
END
GO 