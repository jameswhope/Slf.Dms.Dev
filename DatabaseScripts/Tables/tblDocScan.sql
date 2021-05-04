/****** Object:  Table [dbo].[tblDocScan]    Script Date: 11/19/2007 11:03:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblDocScan](
	[DocScanID] [int] IDENTITY(1,1) NOT NULL,
	[DocID] [nvarchar](25) NOT NULL,
	[Origin] [nvarchar](50) NULL,
	[ReceivedDate] [datetime] NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL
) ON [PRIMARY]
GO
