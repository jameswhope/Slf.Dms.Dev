/****** Object:  Table [dbo].[tblRuleNegotiation]    Script Date: 11/19/2007 11:04:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRuleNegotiation](
	[RuleNegotiationID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[RangeStart] [varchar](2) NOT NULL,
	[RangeEnd] [varchar](2) NOT NULL,
	[LastModified] [datetime] NOT NULL CONSTRAINT [DF_tblRuleNegotiation_LastModified]  DEFAULT (getdate()),
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblRuleNegotiationAssignment] PRIMARY KEY CLUSTERED 
(
	[RuleNegotiationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
