/****** Object:  Table [dbo].[tblBouncedReasons]    Script Date: 11/19/2007 11:02:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblBouncedReasons](
	[BouncedID] [int] NOT NULL,
	[BouncedCode] [nvarchar](3) NULL,
	[BouncedDescription] [nvarchar](200) NULL
) ON [PRIMARY]
GO
