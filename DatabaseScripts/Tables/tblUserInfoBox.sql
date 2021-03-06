/****** Object:  Table [dbo].[tblUserInfoBox]    Script Date: 11/19/2007 11:04:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserInfoBox](
	[UserInfoBoxID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[InfoBoxID] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblUserInfoBox] PRIMARY KEY CLUSTERED 
(
	[UserInfoBoxID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
