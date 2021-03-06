/****** Object:  Table [dbo].[tblRuleCommColor]    Script Date: 11/19/2007 11:04:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRuleCommColor](
	[RuleCommColorID] [int] IDENTITY(1,1) NOT NULL,
	[EntityType] [varchar](50) NOT NULL,
	[EntityID] [int] NOT NULL,
	[Color] [varchar](50) NULL,
	[TextColor] [varchar](50) NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblRuleCommColor] PRIMARY KEY CLUSTERED 
(
	[RuleCommColorID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
