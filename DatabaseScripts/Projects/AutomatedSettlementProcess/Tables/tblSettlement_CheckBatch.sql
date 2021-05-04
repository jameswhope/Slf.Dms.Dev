IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlement_CheckBatch')
	BEGIN
		DROP  Table tblSettlement_CheckBatch
	END
GO

CREATE TABLE [dbo].[tblSettlement_CheckBatch](
	[ProcessBatchId] [int] IDENTITY(1,1) NOT NULL,
	[RequestedBy] [int] NOT NULL,
	[RequestStartDate] [datetime] NOT NULL,
	[RequestEndDate] [datetime] NULL,
 CONSTRAINT [PK_tblSettlement_CheckBatch] PRIMARY KEY CLUSTERED 
(
	[ProcessBatchId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


GRANT SELECT ON tblSettlement_CheckBatch TO PUBLIC

GO

