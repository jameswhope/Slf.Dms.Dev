 /****** Object:  Table [dbo].[tblTimeOff]    Script Date: 01/14/2011 16:25:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblTimeOff]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblTimeOff](
	[TimeOffID] [int] IDENTITY(1,1) NOT NULL,
	[YearsOfService] [int] NULL,
	[HoursOff] [decimal](18, 0) NULL
) ON [PRIMARY]
END
GO