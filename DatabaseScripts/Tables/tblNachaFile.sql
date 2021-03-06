/****** Object:  Table [dbo].[tblNachaFile]    Script Date: 11/19/2007 11:03:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblNachaFile](
	[NachaFileId] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[EffectiveDate] [datetime] NOT NULL,
 CONSTRAINT [PK_tblNachaFile] PRIMARY KEY CLUSTERED 
(
	[NachaFileId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
