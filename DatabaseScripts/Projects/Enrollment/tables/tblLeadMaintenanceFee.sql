IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadMaintenanceFee')
	BEGIN
CREATE TABLE [dbo].[tblLeadMaintenanceFee](
	[MaintenanceFeeID] [int] IDENTITY(1,1) NOT NULL,
	[MaintenanceFee] [numeric](18, 2) NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[TypeFlag] [char](3) NULL,
 CONSTRAINT [PK_tblLeadMaintenanceFee] PRIMARY KEY CLUSTERED 
(
	[MaintenanceFeeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
	END


