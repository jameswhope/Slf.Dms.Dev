IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlementProcessingApproval')
	BEGIN
		DROP  Table tblSettlementProcessingApproval
	END


CREATE TABLE [dbo].[tblSettlementProcessingApproval](
	[SettlementProcessingApprovalID] [int] IDENTITY(1,1) NOT NULL,
	[SettlementID] [int] NOT NULL,
	[PendingAmount] [money] NOT NULL,
	[Approved] [bit] NOT NULL CONSTRAINT [DF_tblSettlementProcessingApproval_Approved]  DEFAULT ((0))
) ON [PRIMARY]


GRANT SELECT ON tblSettlementProcessingApproval TO PUBLIC
