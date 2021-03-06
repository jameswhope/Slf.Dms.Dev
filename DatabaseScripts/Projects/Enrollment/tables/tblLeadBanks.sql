IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadBanks')
	BEGIN
		CREATE TABLE [dbo].[tblLeadBanks](
			[LeadBankID] [int] IDENTITY(1,1) NOT NULL,
			[LeadApplicantID] [int] NOT NULL,
			[BankID] [int] NOT NULL,
			[AccountNumber] [nvarchar](50) NULL,
			[RoutingNumber] [nchar](9) NULL,
			[Created] [datetime] NULL,
			[CreatedByID] [int] NULL,
			[LastModified] [datetime] NULL,
			[LastModifiedByID] [int] NULL,
			[BankName] [nvarchar](150) NULL,
			[Street] [nvarchar](100) NULL,
			[Street2] [nvarchar](100) NULL,
			[City] [nvarchar](100) NULL,
			[StateID] [int] NULL,
			[ZipCode] [nvarchar](50) NULL,
			[PhoneNumber] [nvarchar](15) NULL,
			[Extension] [nvarchar](10) NULL,
			[Checking] [bit] NULL,
		 CONSTRAINT [PK_tblLeadBanks] PRIMARY KEY CLUSTERED 
		(
			[LeadBankID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END