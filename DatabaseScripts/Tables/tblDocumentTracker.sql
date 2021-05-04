/****** Object:  Table [dbo].[tblDocumentTracker]    Script Date: 11/19/2007 11:03:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblDocumentTracker](
	[DocumenTrackerID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[DocID] [nvarchar](10) NOT NULL,
	[DocTypeID] [nvarchar](50) NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [datetime] NOT NULL
) ON [PRIMARY]
GO
