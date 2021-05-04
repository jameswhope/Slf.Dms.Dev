IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNonDepositPendingCancellation')
	BEGIN
		CREATE TABLE tblNonDepositPendingCancellation
		(
		   CancellationId int not null identity(1,1) Primary Key,
		   ClientId int not null,
		   Created Datetime not null,
		   CreatedBy int not null,
		   Deleted DateTime null,
		   DeletedBy int null
		)
	END
GO




