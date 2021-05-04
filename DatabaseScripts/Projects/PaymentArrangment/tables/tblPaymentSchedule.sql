IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblPaymentSchedule')
	BEGIN
		CREATE TABLE [tblPaymentSchedule](
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
		 CONSTRAINT [PK_tblPaymentSchedule] PRIMARY KEY CLUSTERED 
		(
			[PmtScheduleID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]

		

		ALTER TABLE tblPaymentSchedule ADD  CONSTRAINT [DF_tblPaymentSchedule_Created]  DEFAULT (getdate()) FOR [Created]
	

		ALTER TABLE tblPaymentSchedule ADD  CONSTRAINT [DF_tblPaymentSchedule_LastModified]  DEFAULT (getdate()) FOR [LastModified]


	END


GRANT SELECT ON tblPaymentSchedule TO PUBLIC

GO

