/****** Object:  Table [dbo].[tblNegotiationFilterDetail]    Script Date: 01/28/2008 13:19:17 ******/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNegotiationFilterDetail')
	BEGIN
			alter table tblNegotiationFilterDetail alter column FirstInput varchar(max)
	END	
ELSE
BEGIN

EXEC ('
CREATE TABLE [dbo].[tblNegotiationFilterDetail](
	[FilterDetailId] [int] IDENTITY(1,1) NOT NULL,
	[FilterId] [int] NOT NULL,
	[FilterType] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sequence] [int] NULL,
	[FieldName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Operation] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OperationVisible] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstInput] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstInputVisible] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[JoinClause] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[JoinClauseVisible] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PctOf] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PctOfVisible] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PctField] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PctFieldVisible] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Created] [datetime] NULL,
	[Modified] [datetime] NULL,
 CONSTRAINT [PK_tblNegotiationCriteriaDetail] PRIMARY KEY CLUSTERED 
(
	[FilterDetailId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
')
END
GO