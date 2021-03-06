/****** Object:  Table [dbo].[tblClientSearch]    Script Date: 11/19/2007 11:03:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblClientSearch](
	[ClientSearchID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[Type] [varchar](500) NULL,
	[Name] [varchar](500) NULL,
	[AccountNumber] [varchar](500) NULL,
	[SSN] [varchar](500) NULL,
	[Address] [varchar](8000) NULL,
	[ContactType] [varchar](8000) NULL,
	[ContactNumber] [varchar](8000) NULL,
 CONSTRAINT [PK_tblClientSearch] PRIMARY KEY CLUSTERED 
(
	[ClientSearchID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
