IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = '[BAISummary]')
	BEGIN
		DROP  Table [BAISummary]
	END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BAISummary](
	[BAISummaryID] [int] IDENTITY(1,1) NOT NULL,
	[DateField] [datetime] NULL,
	[ABA_RoutingField] [nvarchar](9) NULL,
	[AccountField] [nvarchar](50) NULL,
	[BAI_Code] [int] NULL,
	[BAI_Description] [nvarchar](255) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Count] [int] NULL,
	[Funds_Type] [nvarchar](50) NULL,
 CONSTRAINT [PK_BAISummary] PRIMARY KEY CLUSTERED 
(
	[BAISummaryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
GRANT SELECT ON [BAISummary] TO PUBLIC

GO
*/
