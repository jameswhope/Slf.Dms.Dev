/****** Object:  Table [dbo].[tblRegisterSet]    Script Date: 11/19/2007 11:04:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRegisterSet](
	[RegisterSetID] [int] IDENTITY(1,1) NOT NULL,
	[Created] [datetime] NOT NULL CONSTRAINT [DF_tblRegisterSet_Created]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblRegisterSet] PRIMARY KEY CLUSTERED 
(
	[RegisterSetID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
