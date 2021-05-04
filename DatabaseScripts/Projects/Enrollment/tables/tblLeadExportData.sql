
CREATE TABLE [dbo].[tblLeadExportData](
	[LeadExportDataID] [int] IDENTITY(1,1) NOT NULL,
	[ExportData] [varchar](max) NULL,
	[Exception] [varchar](max) NULL,
	[Created] [datetime] NOT NULL DEFAULT (getdate())
) 