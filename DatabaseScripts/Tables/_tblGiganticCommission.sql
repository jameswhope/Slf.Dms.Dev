/****** Object:  Table [dbo].[_tblGiganticCommission]    Script Date: 11/19/2007 11:02:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[_tblGiganticCommission](
	[GiganticCommissionID] [int] IDENTITY(1,1) NOT NULL,
	[GiganticQueryID] [int] NOT NULL,
	[CommRecID] [int] NOT NULL,
	[Abbreviation] [nvarchar](50) NOT NULL,
	[Amount] [money] NOT NULL
) ON [PRIMARY]
GO
