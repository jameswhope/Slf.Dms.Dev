 USE [Payroll]
GO
/****** Object:  Table [dbo].[tblSSandMedicare]    Script Date: 01/11/2011 15:50:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblSSandMedicare]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblSSandMedicare](
	[SSandMedicareID] [int] NULL,
	[YearWagesPaid] [int] NULL,
	[SSBaseLimit] [money] NULL,
	[SSTaxRate] [decimal](18, 2) NULL,
	[MedicareBaseLimit] [money] NULL,
	[MedicareTaxRate] [decimal](18, 2) NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL
) ON [PRIMARY]
END