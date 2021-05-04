
if object_id('tblCreditLiabilityLookup') is null begin
	CREATE TABLE [dbo].[tblCreditLiabilityLookup](
		[CreditLiabilityLookupID] [int] IDENTITY(1,1) NOT NULL,
		[CreditorID] [int] NULL,
		[CreditorName] [varchar](50) NOT NULL,
		[Street] [varchar](75) NOT NULL,
		[City] [varchar](30) NOT NULL,
		[StateCode] [varchar](10) NOT NULL,
		[PostalCode] [varchar](15) NOT NULL,
		[Contact] [varchar](20) NOT NULL,
		[Created] [datetime] NOT NULL DEFAULT (getdate()),
		[CreditorIdUpdated] [datetime] NULL,
		[CreditorIdUpdatedBy] [int] NULL,
	PRIMARY KEY CLUSTERED 
	(
		[CreditLiabilityLookupID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
	) ON [PRIMARY]
end 