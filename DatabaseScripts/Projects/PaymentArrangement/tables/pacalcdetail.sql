IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblPAcalcdetail')
	BEGIN
		Create Table tblPAcalcdetail(
			padetailid int not null identity(1,1) primary key clustered,
			pasessionid int not null,
			created datetime not null default getdate(),
			createdby int not null,
			lastmodified datetime not null default getdate(),
			lastmodifiedby int not null,
			paymentDueDate datetime not null,
			paymentamount money not null,
			deleted datetime null,
			deletedby int null
		)
	END
GO
