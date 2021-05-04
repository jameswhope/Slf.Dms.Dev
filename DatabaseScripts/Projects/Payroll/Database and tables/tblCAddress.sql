 USE [Payroll]
GO
/****** Object:  Table [dbo].[tblCAddress]    Script Date: 01/11/2011 15:47:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblCAddress]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblCAddress](
	[CAddressID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyID] [int] NULL,
	[Street] [nvarchar](50) NULL,
	[Street2] [nvarchar](50) NULL,
	[City] [nvarchar](50) NULL,
	[State] [nvarchar](50) NULL,
	[Zip] [nvarchar](50) NULL,
	[Country] [nvarchar](50) NULL,
	[Headquarters] [bit] NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL
) ON [PRIMARY]
END