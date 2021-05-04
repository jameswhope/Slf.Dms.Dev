IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblTMLF2LEXX')
	BEGIN
		create table tblTMLF2LEXX (
		RecordID int IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED
		,TransactionDate datetime NOT NULL
		,TransactionType nvarchar(255) NOT NULL
		,RefTable nvarchar(25)
		,RefTableID int
		,OriginalCommRecID int
		,OriginalAmount decimal(18,2) DEFAULT 0.00
		,NewAmount decimal(18,2) DEFAULT 0.00
		,TransactionAmount decimal(18,2) DEFAULT 0.00
		,PaidToCommRecID int 
		,BalanceDue decimal(18,2) DEFAULT 0.00
		,Created datetime DEFAULT GETDATE()
		,CreatedBy int)
	END
GO
