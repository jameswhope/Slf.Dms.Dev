IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlementVerification')
	BEGIN
		DROP  Table tblSettlementVerification
	END
GO

CREATE TABLE [dbo].[tblSettlementVerification](
	[SettlementVerificationID] [int] IDENTITY(1,1) NOT NULL,
	[SettlementID] [int] NOT NULL,
	[RoadmapID] [int] NOT NULL,
	[Note] [nvarchar](max) NOT NULL
) ON [PRIMARY]