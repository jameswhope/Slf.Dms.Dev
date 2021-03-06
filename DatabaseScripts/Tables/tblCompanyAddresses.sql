/****** Object:  Table [dbo].[tblCompanyAddresses]    Script Date: 11/19/2007 11:03:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyAddresses](
	[CompanyAddressID] [int] IDENTITY(1,1) NOT NULL,
	[AddressTypeID] [int] NOT NULL,
	[CompanyID] [int] NOT NULL,
	[Address1] [nvarchar](150) NOT NULL,
	[Address2] [nvarchar](150) NULL,
	[City] [nvarchar](75) NOT NULL,
	[State] [nvarchar](2) NOT NULL,
	[Zipcode] [nvarchar](15) NOT NULL,
	[Option1] [nvarchar](200) NULL,
	[date_created] [datetime] NOT NULL CONSTRAINT [DF_tblAttorneyAddress_date_created]  DEFAULT (getdate()),
 CONSTRAINT [PK_tblAttorneyAddress] PRIMARY KEY CLUSTERED 
(
	[CompanyAddressID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblCompanyAddresses]  WITH CHECK ADD  CONSTRAINT [FK_tblAttorneyAddress_tblAttorneyAddress1] FOREIGN KEY([CompanyAddressID])
REFERENCES [dbo].[tblCompanyAddresses] ([CompanyAddressID])
GO
ALTER TABLE [dbo].[tblCompanyAddresses] CHECK CONSTRAINT [FK_tblAttorneyAddress_tblAttorneyAddress1]
GO
