IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblTranAdjustedReason')
	BEGIN
		CREATE TABLE tblTranAdjustedReason
			(
				[TranAdjustedReasonID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
				[DisplayName] [nvarchar](50) NULL,
				[Reason] [nvarchar](50) NULL
			) ON [PRIMARY]
	END
GO

