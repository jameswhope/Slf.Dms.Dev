/****** Object:  Table [dbo].[tblDataEntry]    Script Date: 11/19/2007 11:03:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblDataEntry](
	[DataEntryID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[DataEntryTypeID] [int] NOT NULL,
	[Conducted] [datetime] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblDataEntry] PRIMARY KEY CLUSTERED 
(
	[DataEntryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
