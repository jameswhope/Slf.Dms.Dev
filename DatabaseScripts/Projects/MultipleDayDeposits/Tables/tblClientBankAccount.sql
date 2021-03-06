IF NOT EXISTS (SELECT 1 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' 
    AND TABLE_NAME='tblClientBankAccount') 

GO
/****** Object:  Table [dbo].[tblClientBankAccount]    Script Date: 03/11/2009 14:13:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblClientBankAccount](
	[BankAccountId] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[RoutingNumber] [varchar](9) NOT NULL,
	[AccountNumber] [varchar](50) NULL,
	[BankType] [varchar](1) NULL,
	[Created] [datetime] NOT NULL DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF