IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlementProcessing')
	BEGIN
		DROP  Table tblSettlementProcessing
	END
GO

CREATE TABLE [dbo].[tblSettlementProcessing](
	[SettlementProcessingID] [int] IDENTITY(1,1) NOT NULL,
	[SettlementID] [int] NOT NULL,
	[UserID] [int] NULL
) ON [PRIMARY]