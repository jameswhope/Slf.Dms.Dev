 USE [Payroll]
GO
/****** Object:  Table [dbo].[tblCompany]    Script Date: 01/11/2011 15:47:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblCompany]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblCompany](
	[CompanyID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nvarchar](150) NULL,
	[FedEINNumber] [nvarchar](50) NULL,
	[StateIDNumber] [nvarchar](50) NULL,
	[Founded] [nvarchar](50) NULL,
	[CurrentStatus] [nvarchar](50) NULL,
	[WorkmansCompID] [nvarchar](50) NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL
) ON [PRIMARY]
END