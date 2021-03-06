/****** Object:  Table [dbo].[tblClientQueue]    Script Date: 11/19/2007 11:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblClientQueue](
	[ClientQueueID] [int] IDENTITY(1,1) NOT NULL,
	[AgencyID] [int] NOT NULL,
	[Col] [int] NOT NULL,
	[Row] [int] NOT NULL,
	[Value] [varchar](255) NULL,
 CONSTRAINT [PK_tblClientQueue] PRIMARY KEY CLUSTERED 
(
	[ClientQueueID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
