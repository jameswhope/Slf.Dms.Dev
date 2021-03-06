/****** Object:  Table [dbo].[tblCheckToPrint]    Script Date: 11/19/2007 11:03:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCheckToPrint](
	[CheckToPrintID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NULL,
	[SpouseFirstName] [varchar](50) NULL,
	[SpouseLastName] [varchar](50) NULL,
	[Street] [varchar](255) NULL,
	[Street2] [varchar](255) NULL,
	[City] [varchar](50) NULL,
	[StateAbbreviation] [varchar](50) NULL,
	[StateName] [varchar](50) NULL,
	[ZipCode] [varchar](50) NULL,
	[AccountNumber] [varchar](50) NULL,
	[BankName] [varchar](50) NULL,
	[BankCity] [varchar](50) NULL,
	[BankStateAbbreviation] [varchar](50) NULL,
	[BankStateName] [varchar](50) NULL,
	[BankZipCode] [varchar](50) NULL,
	[BankRoutingNumber] [varchar](9) NOT NULL,
	[BankAccountNumber] [varchar](50) NOT NULL,
	[Amount] [money] NOT NULL,
	[CheckNumber] [varchar](50) NOT NULL,
	[CheckDate] [datetime] NULL,
	[Fraction] [varchar](50) NOT NULL,
	[Printed] [datetime] NULL,
	[PrintedBy] [int] NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblCheckToPrint] PRIMARY KEY CLUSTERED 
(
	[CheckToPrintID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
