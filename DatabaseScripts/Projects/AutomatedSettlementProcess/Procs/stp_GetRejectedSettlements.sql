IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetRejectedSettlements')
	BEGIN
		DROP  Procedure  stp_GetRejectedSettlements
	END

GO

CREATE Procedure [dbo].[stp_GetRejectedSettlements]
(
	@year int,
	@month int
)

AS
BEGIN

	SELECT
		s.SettlementId,
		s.SettlementAmount,
		s.SettlementDueDate AS SettlementDueDate,
		c.ClientId,
		s.CreditorAccountId AS AccountId,	
		p.FirstName + ' ' + p.LastName AS ClientName,
		com.[Name] AS Firm,
		cr.[Name] AS CreditorName,
		n.[Value] AS Note,
		sc.ApprovalType,
		crr.ReasonName AS Reason,
		AvailSDA AS AvailableSDABalance,
		n.created
	FROM
		tblSettlements s inner join
		tblSettlementClientApproval sc ON sc.MatterId = s.MatterId and sc.ReasonId is not null inner join
		tblClientRejectionReason crr ON crr.ReasonId = sc.ReasonId inner join
		tblClient c ON c.ClientId = s.ClientId inner join
		tblPerson p ON p.Personid = c.PrimaryPersonId inner join
		tblCompany com ON c.CompanyId = com.CompanyId inner join
		tblAccount a ON a.AccountId = s.CreditorAccountId inner join
		tblCreditorInstance ci ON ci.CreditorInstanceId = a.CurrentCreditorInstanceId inner join
		tblCreditor cr ON cr.CreditorId = ci.CreditorId  inner join
		tblNote n ON n.NoteId = sc.NoteId and month(n.Created) = @month and year(n.Created) = @year 
	ORDER BY s.SettlementId
END

GO


GRANT EXEC ON stp_GetRejectedSettlements TO PUBLIC

GO


