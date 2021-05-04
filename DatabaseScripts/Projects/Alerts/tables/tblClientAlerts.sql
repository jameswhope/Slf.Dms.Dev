CREATE TABLE [dbo].[tblClientAlerts](
	[AlertID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[AlertType] [int] NOT NULL,
	[AlertDescription] [varchar](max) NOT NULL,
	[AlertRelationType] [varchar](200) NOT NULL,
	[AlertRelationID] [numeric](18, 0) NOT NULL,
	[Created] [datetime] NOT NULL CONSTRAINT [DF_tblClientAlerts_Created]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[Resolved] [datetime] NULL,
	[ResolvedBy] [int] NULL,
	[Deleted] [bit] default(0) not null,
 CONSTRAINT [PK_tblClientAlerts] PRIMARY KEY CLUSTERED 
(
	[AlertID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = OFF, ALLOW_PAGE_LOCKS  = OFF, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] 