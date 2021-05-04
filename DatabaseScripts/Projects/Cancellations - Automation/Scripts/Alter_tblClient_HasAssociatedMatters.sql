 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblClient')
	BEGIN
		IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblClient' AND column_name='HasAssociatedMatters')
			BEGIN
				ALTER TABLE tblClient Add HasAssociatedMatters bit NULL
			END
	END