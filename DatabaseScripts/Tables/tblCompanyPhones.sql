/****** Object:  Table [dbo].[tblCompanyPhones]    Script Date: 11/19/2007 11:03:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyPhones](
	[CompanyPhoneID] [int] NOT NULL,
	[CompanyID] [int] NOT NULL,
	[PhoneType] [int] NOT NULL,
	[PhoneNumber] [nvarchar](15) NOT NULL
) ON [PRIMARY]
GO
