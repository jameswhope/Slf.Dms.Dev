/****** Object:  Table [dbo].[tblClientStatus]    Script Date: 11/19/2007 11:03:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblClientStatus](
	[ClientStatusID] [int] IDENTITY(1,1) NOT NULL,
	[ParentClientStatusID] [int] NULL,
	[Name] [varchar](50) NOT NULL,
	[Code] [varchar](8) NOT NULL,
	[Order] [int] NOT NULL CONSTRAINT [DF_tblClientStatus_Order]  DEFAULT (0),
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblClientStatus] PRIMARY KEY CLUSTERED 
(
	[ClientStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
