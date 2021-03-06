/****** Object:  Table [dbo].[tblDataEntryPropagation]    Script Date: 11/19/2007 11:03:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblDataEntryPropagation](
	[DataEntryPropagationID] [int] IDENTITY(1,1) NOT NULL,
	[DataEntryTypeID] [int] NOT NULL,
	[Order] [int] NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[TypeID] [int] NOT NULL,
	[Due] [money] NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblDataEntryPropagation] PRIMARY KEY CLUSTERED 
(
	[DataEntryPropagationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
