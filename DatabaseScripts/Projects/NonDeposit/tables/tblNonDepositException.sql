IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNonDepositException')
	BEGIN
		Create Table tblNonDepositException(
			NonDepositExceptionId int not null identity(1,1) Primary Key,
			PlanId int not null,
			Fixed bit not null default 0
		)
	END
GO

