/****** Object:  Table [dbo].[tblAuditColumn]    Script Date: 11/19/2007 11:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblAuditColumn](
	[AuditColumnID] [int] IDENTITY(1,1) NOT NULL,
	[AuditTableID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsBigValue] [bit] NOT NULL CONSTRAINT [DF_tblAuditColumn_IsBigValue]  DEFAULT (0),
 CONSTRAINT [PK_tblAuditColumn] PRIMARY KEY CLUSTERED 
(
	[AuditColumnID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
