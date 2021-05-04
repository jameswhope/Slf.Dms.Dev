/****** Object:  Table [dbo].[tblEmployee]    Script Date: 01/11/2011 15:44:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEmployee]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblEmployee](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[SSN] [char](11) NULL,
	[Salutation] [varchar](10) NULL,
	[FirstName] [varchar](50) NULL,
	[MiddleName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[BirthDate] [datetime] NULL,
	[Age]  AS (datediff(year,[BirthDate],getdate())),
	[Gender] [char](1) NULL,
	[Disabled] [bit] NULL,
	[CurrentStatus] [nvarchar](50) NULL,
	[W4Allowances] [nvarchar](2) NULL,
	[Exempt] [bit] NULL,
	[CurrentTitle] [nvarchar](50) NULL,
	[EmployeeType] [char](2) NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tblEmployee', N'COLUMN',N'Age'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Employee''s age' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblEmployee', @level2type=N'COLUMN',@level2name=N'Age'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tblEmployee', N'COLUMN',N'CurrentStatus'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Employeed - Laid-Off - Discharged' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblEmployee', @level2type=N'COLUMN',@level2name=N'CurrentStatus'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tblEmployee', N'COLUMN',N'EmployeeType'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(H) hourly, (S) salaried, (C) contract, (T) temporary' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblEmployee', @level2type=N'COLUMN',@level2name=N'EmployeeType' 