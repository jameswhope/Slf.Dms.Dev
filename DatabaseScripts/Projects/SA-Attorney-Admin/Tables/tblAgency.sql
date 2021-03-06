IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAgency')
	BEGIN
		PRINT 'Add Columns'
		IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'tblAgency' AND column_name = 'Contact1' )
				ALTER TABLE tblAgency ADD 	[Contact1] [varchar](75) NULL
		IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'tblAgency' AND column_name = 'Contact2' )
				ALTER TABLE tblAgency ADD 	[Contact2] [varchar](75) NULL
		IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'tblAgency' AND column_name = 'IsCommRec' )
				ALTER TABLE tblAgency ADD [IsCommRec] [bit] NOT NULL DEFAULT 0
	END
ELSE
	BEGIN
		EXEC('CREATE TABLE [dbo].[tblAgency](
			[AgencyID] [int] IDENTITY(1,1) NOT NULL,
			[Code] [varchar](10) NOT NULL,
			[Name] [varchar](255) NOT NULL,
			[ImportAbbr] [varchar](25) NULL,
			[Commercial] [bit] NOT NULL CONSTRAINT [DF_tblAgency_Commerical]  DEFAULT ((0)),
			[EIN] [varchar](50) NULL,
			[UserId] [int] NULL,
			[PrimaryAgentID] [int] NULL,
			[RetainerFeePercent] [float] NULL,
			[SettlementFeePercent] [float] NULL,
			[MaintenanceFee] [float] NULL,
			[MaintenanceFeeDay] [int] NULL,
			[AdditionalAccountFee] [float] NULL,
			[ReturnedCheckFee] [float] NULL,
			[OvernightFee] [float] NULL,
			[Created] [datetime] NOT NULL,
			[CreatedBy] [int] NOT NULL,
			[LastModified] [datetime] NOT NULL,
			[LastModifiedBy] [int] NOT NULL,
			[CheckingSavings] [varchar](1) NULL,
		 CONSTRAINT [PK_tblAgency] PRIMARY KEY CLUSTERED 
		(
			[AgencyID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
		) ON [PRIMARY]
 		EXEC sys.sp_addextendedproperty @name=N''MS_Description'', @value=N''Will be either an S or a C for Checking and Savings'' , @level0type=N''SCHEMA'',@level0name=N''dbo'', @level1type=N''TABLE'',@level1name=N''tblAgency'', @level2type=N''COLUMN'',@level2name=N''CheckingSavings''
 		')
	END	
GO
