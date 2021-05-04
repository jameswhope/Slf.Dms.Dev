IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadProductDID')
	BEGIN
		CREATE Table tblLeadProductDID(
			ProductId int not null,
			DID varchar(10) not null
		)
	END
GO

 