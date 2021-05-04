/****** Object:  Table [dbo].[tblNachaReporting]    Script Date: 11/19/2007 11:03:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblNachaReporting](
	[NachaRegisterId] [int] NOT NULL,
	[NachaFileId] [int] NULL,
	[Name] [varchar](50) NOT NULL,
	[AccountNumber] [varchar](50) NOT NULL,
	[RoutingNumber] [varchar](9) NOT NULL,
	[Type] [varchar](1) NOT NULL,
	[Amount] [money] NOT NULL,
	[IdTidbit] [varchar](50) NULL,
	[IsPersonal] [bit] NOT NULL,
	[CommRecId] [int] NOT NULL,
	[IsDeclined] [bit] NOT NULL,
	[DeclinedReason] [varchar](255) NULL,
	[DeclinedDate] [datetime] NULL,
	[CompanyID] [int] NULL,
	[TransferDate] [datetime] NULL,
	[Bounced] [bit] NULL,
	[BouncedDate] [datetime] NULL,
	[Credited] [bit] NULL,
	[CreditedDate] [datetime] NULL,
	[Voided] [bit] NULL,
	[VoidedDateTime] [datetime] NULL,
	[ClientAccountNo] [nchar](10) NULL,
	[ClientID] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
