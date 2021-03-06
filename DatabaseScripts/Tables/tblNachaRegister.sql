/****** Object:  Table [dbo].[tblNachaRegister]    Script Date: 11/19/2007 11:03:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblNachaRegister](
	[NachaRegisterId] [int] IDENTITY(1,1) NOT NULL,
	[NachaFileId] [int] NULL,
	[Name] [varchar](50) NOT NULL,
	[AccountNumber] [varchar](50) NOT NULL,
	[RoutingNumber] [varchar](9) NOT NULL,
	[Type] [varchar](1) NOT NULL CONSTRAINT [DF_tblNachaRegister_Type]  DEFAULT ('C'),
	[Amount] [money] NOT NULL,
	[IdTidbit] [varchar](50) NULL,
	[IsPersonal] [bit] NOT NULL CONSTRAINT [DF_tblNachaRegister_IsPersonal]  DEFAULT ((1)),
	[CommRecId] [int] NOT NULL,
	[IsDeclined] [bit] NOT NULL CONSTRAINT [DF_tblNachaRegister_IsDeclined]  DEFAULT ((0)),
	[DeclinedReason] [varchar](255) NULL,
	[DeclinedDate] [datetime] NULL,
	[CompanyID] [int] NULL,
 CONSTRAINT [PK_tblNachaRegister] PRIMARY KEY CLUSTERED 
(
	[NachaRegisterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
