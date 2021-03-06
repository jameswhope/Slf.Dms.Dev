/****** Object:  Table [dbo].[tblCompanyAddressTypes]    Script Date: 11/19/2007 11:03:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCompanyAddressTypes](
	[AddressTypeID] [int] IDENTITY(1,1) NOT NULL,
	[AddressTypeName] [varchar](100) NOT NULL,
	[date_created] [datetime] NOT NULL CONSTRAINT [DF_AttorneyAddressTypes_date_created]  DEFAULT (getdate()),
 CONSTRAINT [PK_tblAttorneyAddressTypes] PRIMARY KEY CLUSTERED 
(
	[AddressTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
