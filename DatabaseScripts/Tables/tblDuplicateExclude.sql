/****** Object:  Table [dbo].[tblDuplicateExclude]    Script Date: 11/19/2007 11:03:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblDuplicateExclude](
	[DuplicateExcludeID] [int] IDENTITY(1,1) NOT NULL,
	[Table] [varchar](50) NOT NULL,
	[KeyID1] [int] NOT NULL,
	[KeyID2] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblDuplicateExclude] PRIMARY KEY CLUSTERED 
(
	[DuplicateExcludeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
