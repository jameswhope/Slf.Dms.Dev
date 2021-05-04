 /****** Object:  Table [dbo].[tblETimeOff]    Script Date: 01/14/2011 16:24:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblETimeOff]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblETimeOff](
	[ETimeOffID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NULL,
	[TimeOffID] [int] NULL,
	[PTOScheduled] [decimal](18, 0) NULL,
	[PTOTaken] [decimal](18, 0) NULL,
	[UPTOUsed] [decimal](18, 0) NULL,
	[Approved] [datetime] NULL,
	[ApprovedBy] [int] NULL,
	[Denied] [datetime] NULL,
	[DeniedBy] [int] NULL
) ON [PRIMARY]
END
GO