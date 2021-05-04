IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblRuleCheck')
	BEGIN
	CREATE TABLE tblRuleCheck
   (	RuleCheckId int not null identity(1,1) Primary Key Clustered,
		StartDate datetime not null,
		EndDate datetime not null,
		DepositDay int not null,
		DepositAmount money not null,
		Created datetime not null default getdate(),
		CreatedBy int not null,
		LastModified datetime null,
		LastModifiedBy int not null,
		ClientId int not null,
		DateUsed datetime null
	)
	END
GO
