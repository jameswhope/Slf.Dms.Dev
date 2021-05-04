 USE [Payroll]
GO
/****** Object:  Table [dbo].[tblCPhone]    Script Date: 01/11/2011 15:48:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblCPhone]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblCPhone](
	[CPhoneID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyID] [int] NULL,
	[CAddressID] [int] NULL,
	[PrimaryNumber] [nvarchar](50) NULL,
	[SecondaryNumber] [nvarchar](50) NULL,
	[FaxNumber] [nvarchar](50) NULL,
	[EmergencyNumber] [nvarchar](50) NULL,
	[WebSite] [nvarchar](150) NULL,
	[HREmail] [nvarchar](50) NULL,
	[AcctEmail] [nvarchar](50) NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiiedBy] [int] NULL
) ON [PRIMARY]
END