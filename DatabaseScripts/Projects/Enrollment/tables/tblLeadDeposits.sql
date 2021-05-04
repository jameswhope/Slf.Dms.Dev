IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadDeposits')
	BEGIN
		Create  Table tblLeadDeposits(
			LeadDepositId int not null identity(1,1) Primary Key,
			LeadApplicantId int not null,
			DepositDay int not null,
			DepositAmount money,
			Created datetime not null default getdate(),
			CreatedBy int not null,
			LastModified datetime not null,
			LastModifiedBy int not null
		)
	END
GO

