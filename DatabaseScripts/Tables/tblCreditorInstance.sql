/****** Object:  Table [dbo].[tblCreditorInstance]    Script Date: 11/19/2007 11:03:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCreditorInstance](
	[CreditorInstanceID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NOT NULL,
	[CreditorID] [int] NOT NULL,
	[ForCreditorID] [int] NULL,
	[Acquired] [datetime] NOT NULL,
	[Amount] [money] NOT NULL,
	[OriginalAmount] [money] NOT NULL,
	[AccountNumber] [varchar](50) NOT NULL,
	[ReferenceNumber] [varchar](50) NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblCreditorInstanceID] PRIMARY KEY CLUSTERED 
(
	[CreditorInstanceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
