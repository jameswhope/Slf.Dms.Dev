
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblsettlements_deliveryaddresses' AND column_name='Lastmodified')
	BEGIN
		ALTER TABLE tblsettlements_deliveryaddresses ADD Lastmodified datetime NULL
	END		

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblsettlements_deliveryaddresses' AND column_name='LastmodifiedBy')
	BEGIN
		ALTER TABLE tblsettlements_deliveryaddresses ADD LastmodifiedBy int NULL
	END			