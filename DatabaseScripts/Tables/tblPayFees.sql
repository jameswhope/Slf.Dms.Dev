/****** Object:  Table [dbo].[tblPayFees]    Script Date: 11/19/2007 11:04:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPayFees](
	[PayFeesID] [int] IDENTITY(1,1) NOT NULL,
	[RegisterID] [int] NOT NULL,
	[ClientID] [int] NOT NULL,
	[Processed] [bit] NOT NULL,
	[FeeDate] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblPayFees] PRIMARY KEY CLUSTERED 
(
	[PayFeesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
