IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblmatters' AND column_name='MatterCaseNumber')
	BEGIN
		ALTER TABLE tblmatter ADD MatterCaseNumber varchar(200)
	END		  