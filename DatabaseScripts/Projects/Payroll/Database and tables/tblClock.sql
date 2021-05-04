/****** Object:  Table [dbo].[tblClock]    Script Date: 01/14/2011 16:25:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblClock]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblClock](
	[PayRateID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NULL,
	[Date] [datetime] NULL,
	[Classification] [nvarchar](50) NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL
) ON [PRIMARY]
END 