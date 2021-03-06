/****** Object:  Table [dbo].[tblCompany]    Script Date: 11/19/2007 11:03:52 ******/
/*
CREATE TABLE [dbo].[tblCompany](
	[CompanyID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Default] [bit] NOT NULL CONSTRAINT [DF_tblCompany_Default]  DEFAULT (0),
	[ShortCoName] [varchar](50) NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[Contact1] [nvarchar](75) NULL,
	[Contact2] [nvarchar](75) NULL,
	[BillingMessage] [nvarchar](255) NULL,
	[WebSite] [nvarchar](255) NULL,
	[SigPath] [nvarchar](100) NULL,
 CONSTRAINT [PK_tblCompany] PRIMARY KEY CLUSTERED 
(
	[CompanyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
*/