/****** Object:  Table [dbo].[tblUserSearch]    Script Date: 11/19/2007 11:04:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserSearch](
	[UserSearchID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[Search] [datetime] NOT NULL,
	[Terms] [varchar](255) NOT NULL,
	[Results] [int] NOT NULL,
	[ResultsClients] [int] NOT NULL,
	[ResultsNotes] [int] NOT NULL,
	[ResultsCalls] [int] NOT NULL,
	[ResultsTasks] [int] NOT NULL,
	[ResultsEmail] [int] NOT NULL,
	[ResultsPersonnel] [int] NOT NULL,
 CONSTRAINT [PK_tblUserSearch] PRIMARY KEY CLUSTERED 
(
	[UserSearchID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
