IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblmatterclassification' AND column_name='Deleted')
	BEGIN
		ALTER TABLE tblmatterclassification ADD Deleted datetime NULL
	END		 