/****** Object:  Table [dbo].[tblNegotiationFilterAudit]    Script Date: 01/28/2008 13:18:49 ******/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNegotiationFilterAudit')
	BEGIN
			PRINT 'DO NOTHING'
	END	
ELSE
BEGIN

EXEC ('
CREATE TABLE [dbo].[tblNegotiationFilterAudit](
	[FilterAuditId] [int] IDENTITY(1,1) NOT NULL,
	[FilterId] [int] NOT NULL,
	[FilterType] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FilterClause] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FilterText] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AggregateClause] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AuditType] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AuditDate] [datetime] NOT NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_tblNegotiationFilterAudit] PRIMARY KEY CLUSTERED 
(
	[FilterAuditId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

')
END
GO