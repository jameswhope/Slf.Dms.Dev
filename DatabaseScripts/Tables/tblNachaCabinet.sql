/****** Object:  Table [dbo].[tblNachaCabinet]    Script Date: 11/19/2007 11:03:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblNachaCabinet](
	[NachaCabinetID] [int] IDENTITY(1,1) NOT NULL,
	[NachaRegisterID] [int] NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[TypeID] [int] NOT NULL,
 CONSTRAINT [PK_tblNachaRegisterCabinet] PRIMARY KEY CLUSTERED 
(
	[NachaCabinetID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
