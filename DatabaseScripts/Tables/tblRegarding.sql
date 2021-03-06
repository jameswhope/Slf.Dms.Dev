/****** Object:  Table [dbo].[tblRegarding]    Script Date: 11/19/2007 11:04:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRegarding](
	[RegardingID] [int] IDENTITY(1,1) NOT NULL,
	[Table] [varchar](40) NOT NULL,
	[Field] [varchar](40) NOT NULL,
	[FieldID] [varchar](40) NOT NULL,
	[ToTable] [varchar](40) NOT NULL,
	[ToField] [varchar](40) NOT NULL,
	[ToFieldID] [varchar](40) NOT NULL,
 CONSTRAINT [PK_tblRegarding] PRIMARY KEY CLUSTERED 
(
	[RegardingID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
