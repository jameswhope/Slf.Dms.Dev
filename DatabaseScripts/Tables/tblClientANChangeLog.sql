/****** Object:  Table [dbo].[tblClientANChangeLog]    Script Date: 11/19/2007 11:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblClientANChangeLog](
	[ClientANChangeLogId] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[OldAccountNumber] [varchar](50) NULL,
	[NewAccountNumber] [varchar](50) NULL,
	[DateChanged] [datetime] NOT NULL,
	[ChangedBy] [int] NOT NULL CONSTRAINT [DF_tblClientANChangeLog_ChangedBy]  DEFAULT ((-1)),
 CONSTRAINT [PK_tblClientANChangeLog] PRIMARY KEY CLUSTERED 
(
	[ClientANChangeLogId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
