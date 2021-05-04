/****** Object:  Table [dbo].[tblReasons_old]    Script Date: 11/19/2007 11:04:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblReasons_old](
	[ReasonsID] [int] IDENTITY(1,1) NOT NULL,
	[Value] [bigint] NULL,
	[ValueType] [nvarchar](50) NULL,
	[Reason1] [nvarchar](max) NULL,
	[Reason2] [nvarchar](max) NULL,
	[Reason3] [nvarchar](max) NULL,
	[Reason4] [nvarchar](max) NULL,
	[Reason5] [nvarchar](max) NULL,
	[Reason6] [nvarchar](max) NULL,
	[Reason7] [nvarchar](max) NULL,
	[Reason8] [nvarchar](max) NULL,
	[Reason9] [nvarchar](max) NULL,
	[Reason10] [nvarchar](max) NULL
) ON [PRIMARY]
GO
