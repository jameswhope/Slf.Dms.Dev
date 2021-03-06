/****** Object:  Table [dbo].[tblBulkEmailPrint] J. Hope  Script Date: 09/03/2008 16:06:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF object_id('tblBulkEmailPrint') IS NULL BEGIN
CREATE TABLE [dbo].[tblBulkEmailPrint](
	[BulkEmailPrintID] [int] IDENTITY(1,1) NOT NULL,
	[SentByUID] [int] NOT NULL,
	[SentOn] [datetime] NOT NULL,
	[SentTo] [varchar](150) NOT NULL,
	[ListName] [varchar](150) NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF