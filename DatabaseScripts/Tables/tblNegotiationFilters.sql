/****** Object:  Table [dbo].[tblNegotiationFilters]    Script Date: 01/28/2008 13:20:07 ******/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNegotiationFilters')
	BEGIN
			PRINT 'DO NOTHING'
	END	
ELSE
BEGIN

EXEC ('
CREATE TABLE [dbo].[tblNegotiationFilters](
	[FilterId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](600) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FilterClause] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FilterType] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FilterText] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AggregateClause] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GroupBy] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentFilterId] [int] NULL,
	[EntityId] [int] NULL,
	[Created] [datetime] NULL CONSTRAINT [DF_tblNegotiationDistribution_Created]  DEFAULT (getdate()),
	[CreatedBy] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[Deleted] [bit] NULL CONSTRAINT [DF_tblNegotiationFilters_Deleted]  DEFAULT ((0)),
 CONSTRAINT [PK_tblNegotiationFilter] PRIMARY KEY CLUSTERED 
(
	[FilterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
')
END
GO