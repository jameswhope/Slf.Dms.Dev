USE [RESTORED_3]
GO
/****** Object:  Table [dbo].[tblLeadCommission]    Script Date: 06/25/2009 08:42:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblLeadCommission](
	[LeadCommissionID] [int] NOT NULL,
	[CommishType] [int] NOT NULL,
	[Percent] [decimal](10, 8) NULL,
	[MinPercent] [decimal](10, 8) NULL,
	[MaxPercent] [decimal](10, 8) NULL,
	[Amount] [money] NULL,
	[MinAmount] [money] NULL,
	[MaxAmount] [money] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL
) ON [PRIMARY]
