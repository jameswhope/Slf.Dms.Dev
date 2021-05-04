IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblPaymentCommDiffHistory')
	BEGIN
		CREATE TABLE tblPaymentCommDiffHistory(
		[DiscrepancyId] [int] IDENTITY(1,1) NOT NULL,
		[FileName] [varchar](100) NOT NULL,
		[ClientId] [int] NULL,
		[PaymentId] [int] NULL,
		[PaymentDate] [datetime] NULL,
		[RegisterId] [int] NULL,
		[EntryTypeId] [int] NULL,
		[PaymentAmount] [money] NULL,
		[CommissionPaid] [money] NULL
	) ON [PRIMARY]
	END
GO

