IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblPlannedDeposit')
	BEGIN
		Create Table tblPlannedDeposit(
			PlanId int not null identity(1,1) Primary Key Clustered,
			ClientId int not null,
			ScheduledDate datetime not null,
			DepositType varchar(50) not null, --AdHoc, Check, ACH
			MonthlyDepositAmount money not null,
			PartialDepositAmount money not null,
			ExpectedDepositAmount money not null,
			MultiDepositClient bit not null,
			RuleACHId int null,
			RuleCheckId int null,
			AdHocAchId int null,
			ClientDepositId int null,
			FirstDeposit bit not null default 0,
			ZeroAmountRule bit not null default 0,
			CreatedDate datetime not null,
			CreatedBy int not null,
			ProcessedDate datetime null,
			ProcessedBy int null
		)
	END
GO


