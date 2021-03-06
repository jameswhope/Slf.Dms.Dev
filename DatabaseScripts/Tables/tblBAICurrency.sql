/****** Object:  Table [dbo].[tblBAICurrency]    Script Date: 11/19/2007 11:02:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBAICurrency](
	[BAICurrencyID] [int] IDENTITY(1,1) NOT NULL,
	[Country] [varchar](255) NULL,
	[Currency] [varchar](50) NOT NULL,
	[Code] [varchar](3) NOT NULL,
	[DecimalPlaces] [int] NOT NULL,
 CONSTRAINT [PK_tblBAICurrencyCode] PRIMARY KEY CLUSTERED 
(
	[BAICurrencyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
