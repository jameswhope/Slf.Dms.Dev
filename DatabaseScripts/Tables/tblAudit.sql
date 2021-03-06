/****** Object:  Table [dbo].[tblAudit]    Script Date: 11/19/2007 11:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAudit](
	[AuditID] [bigint] IDENTITY(1,1) NOT NULL,
	[AuditColumnID] [int] NOT NULL,
	[PK] [int] NOT NULL,
	[Value] [sql_variant] NULL,
	[DC] [datetime] NOT NULL CONSTRAINT [DF_tblAudit_Created]  DEFAULT (getdate()),
	[UC] [int] NULL,
	[Deleted] [bit] NOT NULL CONSTRAINT [DF_tblAudit_Deleted]  DEFAULT (0),
 CONSTRAINT [PK_tblAudit] PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
