IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDepositRuleCheck')
	BEGIN
		CREATE TABLE tblDepositRuleCheck
(			RuleCheckId int not null identity(1,1) Primary Key Clustered,
			StartDate datetime not null,
			EndDate datetime not null,
			DepositDay int not null,
			DepositAmount money not null,
			Created datetime not null default getdate(),
			CreatedBy int not null,
			LastModified datetime null,
			LastModifiedBy int not null,
			ClientDepositId int not null,
			OldRuleId int null,
			Locked bit not null default 0,
			DateUsed datetime null
)
	END
GO
