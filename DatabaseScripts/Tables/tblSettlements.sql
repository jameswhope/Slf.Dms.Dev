IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlements')
	BEGIN
		/*script from vs2005*/
		IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlements')
			BEGIN
			
				IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblsettlements' AND column_name='SettlementFeeAmtBeingPaid')
					BEGIN
						EXEC sp_rename 'tblsettlements.SettlementAmtBeingPaid','SettlementFeeAmtBeingPaid'
					END
				IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblsettlements' AND column_name='SettlementFeeAmtStillOwed')
					BEGIN
						EXEC sp_rename 'tblsettlements.SettlementAmtStillOwed','SettlementFeeAmtStillOwed'
					END
				IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblsettlements' AND column_name='SettlementAmtStillOwed')
					BEGIN
						EXEC sp_rename 'tblsettlements.SettlementAmtSillOwed','SettlementAmtStillOwed'
					END
				IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblsettlements' AND column_name='SettlementFeeCredit')
					BEGIN
						ALTER TABLE tblsettlements ADD SettlementFeeCredit money NULL
					END					
				IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblsettlements' AND column_name='SettlementSessionGuid')
					BEGIN
						ALTER TABLE tblsettlements ALTER COLUMN SettlementSessionGuid varchar(50) NULL
					END										
			END
	END
else
	begin
		CREATE TABLE [dbo].[tblSettlements](
			[SettlementID] [int] IDENTITY(1,1) NOT NULL,
			[CreditorAccountID] [int] NOT NULL,
			[ClientID] [int] NOT NULL,
			[RegisterBalance] [money] NULL,
			[FrozenAmount] [money] NULL,
			[CreditorAccountBalance] [money] NULL,
			[SettlementPercent] [float] NOT NULL,
			[SettlementAmount] [money] NULL,
			[SettlementAmtAvailable] [money] NULL,
			[SettlementAmtBeingSent] [money] NULL,
			[SettlementAmtStillOwed] [money] NULL,
			[SettlementDueDate] [datetime] NULL,
			[SettlementSavings] [money] NULL,
			[SettlementFee] [money] NULL,
			[OvernightDeliveryAmount] [money] NULL,
			[SettlementCost] [money] NULL,
			[SettlementFeeAmtAvailable] [money] NULL,
			[SettlementFeeAmtBeingPaid] [money] NULL,
			[SettlementFeeAmtStillOwed] [money] NULL,
			[SettlementNotes] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[Status] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[Created] [datetime] NOT NULL CONSTRAINT [DF_tblSettlements_Created]  DEFAULT (getdate()),
			[CreatedBy] [int] NOT NULL,
			[LastModified] [datetime] NOT NULL CONSTRAINT [DF_tblSettlements_LastModified]  DEFAULT (getdate()),
			[LastModifiedBy] [int] NOT NULL,
			[SettlementRegisterHoldID] [int] NULL,
			[OfferDirection] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[SettlementSessionGuid] [uniqueidentifier] NULL,
		 CONSTRAINT [PK_tblSettlements] PRIMARY KEY CLUSTERED 
		(
			[SettlementID] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]
	END

GO

GRANT SELECT ON tblSettlements TO PUBLIC

GO

