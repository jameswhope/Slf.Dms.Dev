/****** Object:  Table [dbo].[tblLeadReasons]    Script Date: 04/17/2009 13:20:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblLeadReasons](
	[LeadReasonsID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[ReasonType] [nvarchar](50) NOT NULL,
	[DisplayOrder] [int] NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblSDReasons] PRIMARY KEY CLUSTERED 
(
	[LeadReasonsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
