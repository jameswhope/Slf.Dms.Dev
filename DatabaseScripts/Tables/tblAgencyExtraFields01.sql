/****** Object:  Table [dbo].[tblAgencyExtraFields01]    Script Date: 11/19/2007 11:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblAgencyExtraFields01](
	[ClientId] [int] NOT NULL,
	[LeadNumber] [varchar](50) NULL,
	[DateSent] [datetime] NULL,
	[DateReceived] [datetime] NULL,
	[SeidemanPullDate] [datetime] NULL,
	[DebtTotal] [float] NULL,
	[MissingInfo] [varchar](255) NULL,
	[NoteID] [int] NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblAgencyExtraFields01] PRIMARY KEY CLUSTERED 
(
	[ClientId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
