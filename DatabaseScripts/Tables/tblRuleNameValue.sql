/****** Object:  Table [dbo].[tblRuleNameValue]    Script Date: 11/19/2007 11:04:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRuleNameValue](
	[RuleNameValueID] [int] IDENTITY(1,1) NOT NULL,
	[RuleTypeID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Value] [sql_variant] NULL,
	[LastModified] [datetime] NOT NULL CONSTRAINT [DF_tblRuleNameValue_LastModified]  DEFAULT (getdate()),
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblRuleNameValue] PRIMARY KEY CLUSTERED 
(
	[RuleNameValueID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
