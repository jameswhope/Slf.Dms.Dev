IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCompanyTrust')
	BEGIN
		DROP  Table [tblCompanyTrust]
	END
GO

CREATE TABLE [dbo].[tblCompanyTrust](
	[CompanyTrustId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [int] NOT NULL,
	[BankDisplayName] [varchar](50) NOT NULL,
	[Street] [varchar](250) NULL,
	[City] [varchar](50) NOT NULL,
	[StateId] [int] NOT NULL,
	[Zip] [nvarchar](15) NOT NULL,
	[RoutingNumber] [varchar](50) NULL,
	[AccountNumber] [varchar](50) NULL
) ON [PRIMARY]
GO

/*
GRANT SELECT ON Table_Name TO PUBLIC

GO
*/
