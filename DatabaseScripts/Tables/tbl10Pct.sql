/****** Object:  Table [dbo].[tbl10Pct]    Script Date: 11/19/2007 11:02:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl10Pct](
	[AccountNumber] [nvarchar](50) NULL,
	[Name] [nvarchar](255) NULL,
	[ClientID] [int] NULL,
	[Is10] [bit] NOT NULL CONSTRAINT [DF_tbl10Pct_Is10]  DEFAULT ((0))
) ON [PRIMARY]
GO
