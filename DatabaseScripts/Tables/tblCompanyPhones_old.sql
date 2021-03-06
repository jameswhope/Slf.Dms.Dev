/****** Object:  Table [dbo].[tblCompanyPhones_old]    Script Date: 11/19/2007 11:03:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyPhones_old](
	[CompanyPhoneID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyID] [int] NOT NULL,
	[PhoneType] [int] NOT NULL,
	[PhoneNumber] [nvarchar](15) NOT NULL,
 CONSTRAINT [PK_tblCompanyPhones] PRIMARY KEY CLUSTERED 
(
	[CompanyPhoneID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
