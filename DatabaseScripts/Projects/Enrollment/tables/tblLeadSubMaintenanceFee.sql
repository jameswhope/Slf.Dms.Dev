USE [DMS_RESTORED]
GO
/****** Object:  Table [dbo].[tblLeadSubMaintenanceFee]    Script Date: 01/08/2009 17:16:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblLeadSubMaintenanceFee](
	[SubMaintenanceFeeID] [int] IDENTITY(1,1) NOT NULL,
	[Amount] [money] NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_tblLeadSubMaintenanceFee] PRIMARY KEY CLUSTERED 
(
	[SubMaintenanceFeeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
