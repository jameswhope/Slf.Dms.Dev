IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblPlannedDepositRegisterXref')
	BEGIN
		Create  Table tblPlannedDepositRegisterXref(
		PlanRegisterId int not null identity(1,1) Primary Key Clustered,
		PlanId int not null,
		RegisterId int not null,
		Amount money not null,
		NonDepositReplacementId int null,
		Created datetime not null default getdate(),
		CreatedBy int not null 
		)
	END
GO

 
