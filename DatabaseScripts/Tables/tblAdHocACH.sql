/****** Object:  Table [dbo].[tblAdHocACH]    Script Date: 11/19/2007 11:02:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblAdHocACH](
	[AdHocAchID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[RegisterID] [int] NULL,
	[DepositDate] [datetime] NOT NULL,
	[DepositAmount] [money] NOT NULL,
	[BankName] [varchar](50) NOT NULL,
	[BankRoutingNumber] [varchar](50) NOT NULL,
	[BankAccountNumber] [varchar](50) NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[BankType] [varchar](1) NULL,
	[InitialDraftYN] [bit] NULL,
 CONSTRAINT [PK_tblAdHocACH] PRIMARY KEY CLUSTERED 
(
	[AdHocAchID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
