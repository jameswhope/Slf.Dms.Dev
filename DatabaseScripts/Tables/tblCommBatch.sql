/****** Object:  Table [dbo].[tblCommBatch]    Script Date: 11/19/2007 11:03:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCommBatch](
	[CommBatchID] [int] IDENTITY(1,1) NOT NULL,
	[CommScenID] [int] NOT NULL,
	[BatchDate] [datetime] NOT NULL,
 CONSTRAINT [PK_tblCommBatch] PRIMARY KEY CLUSTERED 
(
	[CommBatchID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
