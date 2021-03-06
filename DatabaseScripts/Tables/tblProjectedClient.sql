/****** Object:  Table [dbo].[tblProjectedClient]    Script Date: 11/19/2007 11:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblProjectedClient](
	[ProjectedClientID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[MCA] [money] NOT NULL,
	[DA] [money] NOT NULL,
	[EA] [money] NOT NULL,
	[DepositMethod] [varchar](50) NOT NULL,
	[ACH] [bit] NOT NULL,
	[Month] [tinyint] NOT NULL,
	[Year] [int] NOT NULL,
	[ExceptionReason] [varchar](1000) NULL,
 CONSTRAINT [PK_tblProjectedClient] PRIMARY KEY CLUSTERED 
(
	[ProjectedClientID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
