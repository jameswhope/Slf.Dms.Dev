/****** Object:  Table [dbo].[transSDFPFO]    Script Date: 11/19/2007 11:04:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[transSDFPFO](
	[accountnumber] [int] NULL,
	[clientid] [int] NULL,
	[regid] [int] NULL,
	[transdate] [datetime] NULL,
	[desc1] [nvarchar](255) NULL,
	[amount] [decimal](18, 2) NULL,
	[sdabal] [decimal](18, 2) NULL,
	[pfobal] [decimal](18, 2) NULL,
	[tbl] [nvarchar](5) NULL
) ON [PRIMARY]
GO
