IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlementClientApproval')
	BEGIN
		DROP  Table tblSettlementClientApproval
	END
GO

CREATE TABLE [dbo].[tblSettlementClientApproval](
	[SettlementClientApprovalID] [int] IDENTITY(1,1) NOT NULL,
	[SettlementID] [int] NOT NULL,
	[RoadmapID] [int] NOT NULL,
	[ApprovalType] [varchar](50) NOT NULL,
	[Note] [nvarchar](max) NOT NULL
) ON [PRIMARY]