IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlements_PaymentArrangements')
	BEGIN
		CREATE TABLE [dbo].[tblSettlements_PaymentArrangements](
	        [PaymentArrangementID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	        [SettlementID] [numeric](18, 0) NOT NULL,
	        [PaymentDate] [datetime] NOT NULL,
	        [PaymentAmt] [money] NOT NULL,
	        [MonthlyPaymentAmt] [money] NOT NULL,
	        [NumberInstallments] [int] NOT NULL,
	        [Created] [datetime] NOT NULL,
	        [CreatedBy] [int] NOT NULL,
	        [LastModified] [datetime] NOT NULL,
	        [LastModifiedBy] [int] NOT NULL,
	        [DatePaid] [datetime] NULL,
         CONSTRAINT [PK_tblSettlements_PaymentArrangements] PRIMARY KEY CLUSTERED 
        (
	        [PaymentArrangementID] ASC
        )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
        ) ON [PRIMARY]
	END
GO

GRANT SELECT ON tblSettlements_PaymentArrangements TO PUBLIC

GO

ALTER TABLE [dbo].[tblSettlements_PaymentArrangements] ADD  CONSTRAINT [DF_tblSettlements_PaymentArrangements_Created]  DEFAULT (getdate()) FOR [Created]
GO

ALTER TABLE [dbo].[tblSettlements_PaymentArrangements] ADD  CONSTRAINT [DF_tblSettlements_PaymentArrangements_LastModified]  DEFAULT (getdate()) FOR [LastModified]
GO
