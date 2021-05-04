/****** Object:  Table [dbo].[tblParameters]    Script Date: 11/19/2007 11:04:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblParameters](
	[PNo] [int] NOT NULL,
	[ReportNo] [int] NOT NULL,
	[ParameterName] [varchar](75) NULL,
	[ParameterType] [varchar](10) NULL,
	[Parameter] [varchar](75) NULL,
	[ParamaterNumber] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
