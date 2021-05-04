/****** Object:  Table [dbo].[tblTheChrisFile]    Script Date: 11/19/2007 11:04:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTheChrisFile](
	[FIRM] [float] NULL,
	[CLIENTID] [float] NULL,
	[ACCTNO] [float] NULL,
	[CLIENTNAME] [nvarchar](255) NULL,
	[METH] [nvarchar](255) NULL,
	[F6] [float] NULL,
	[SDABAL] [money] NULL,
	[RETFEE] [money] NULL,
	[SETTFEE] [money] NULL,
	[MAINTFEE] [money] NULL
) ON [PRIMARY]
GO
