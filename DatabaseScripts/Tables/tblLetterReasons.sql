/****** Object:  Table [dbo].[tblLetterReasons]    Script Date: 11/19/2007 11:03:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblLetterReasons](
	[LetterName] [varchar](50) NULL,
	[ReasonID] [numeric](18, 0) NOT NULL,
	[ReasonDesc] [varchar](255) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
