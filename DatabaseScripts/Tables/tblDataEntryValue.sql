/****** Object:  Table [dbo].[tblDataEntryValue]    Script Date: 11/19/2007 11:03:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblDataEntryValue](
	[DataEntryValueID] [int] IDENTITY(1,1) NOT NULL,
	[DataEntryID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Value] [varchar](255) NOT NULL,
 CONSTRAINT [PK_tblDataEntryValue] PRIMARY KEY CLUSTERED 
(
	[DataEntryValueID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
