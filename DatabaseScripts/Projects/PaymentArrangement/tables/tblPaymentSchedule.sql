drop table tblPaymentSchedule
CREATE TABLE [dbo].[tblPaymentSchedule](
	[PmtScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[AccountID] [int] NOT NULL,
	[SettlementID] [int] NOT NULL,
	[PmtDate] [datetime] NOT NULL,
	[PmtAmount] [money] NOT NULL,
	[PmtRecdDate] [datetime] NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
	[RegisterID] [int] NULL,
	[PaymentProcessingId] [int] NULL,
	[Deleted] datetime NULL,
	[DeletedBy] [int] NULL
 CONSTRAINT [PK_tblPaymentSchedule] PRIMARY KEY CLUSTERED 
(
	[PmtScheduleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblPaymentSchedule] ADD  CONSTRAINT [DF_tblPaymentSchedule_Created]  DEFAULT (getdate()) FOR [Created]
GO

ALTER TABLE [dbo].[tblPaymentSchedule] ADD  CONSTRAINT [DF_tblPaymentSchedule_LastModified]  DEFAULT (getdate()) FOR [LastModified]
GO


