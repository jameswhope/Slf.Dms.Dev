IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetClientIssues_Settlements')
	BEGIN
		DROP  Procedure  stp_Dialer_GetClientIssues_Settlements
	END

GO

CREATE Procedure stp_Dialer_GetClientIssues_Settlements
@ClientId int
AS
BEGIN

SELECT Distinct
		m.MatterId,
		m.MatterStatusCodeId,
		m.MatterSubStatusId,
		m.MatterDate,
		t.TaskId,
		m.ClientId,
		s.CreditorAccountId,
		t.[Description],
		t.Due As TaskDueDate,
		s.SettlementId,
		s.RegisterBalance,
		s.SettlementAmount,
		s.CreditorAccountBalance,
		s.SettlementPercent,
		s.SettlementDueDate,
		s.SettlementSavings,
		s.SettlementFee,
		s.OvernightDeliveryAmount,
		s.SettlementCost,
		s.SettlementAmtAvailable,
		s.SettlementAmtBeingSent,
		s.SettlementAmtStillOwed,
		s.SettlementFeeAmtAvailable,
		s.SettlementFeeAmtBeingPaid,
		s.SettlementFeeAmtStillOwed,
		c.AccountNumber As ClientAccountNumber,
		p.FirstName + ' ' +	p.LastName As [Client Name],
		ci.Amount As CurrentCreditorAmount,
		ci.OriginalAmount As OriginalCreditorAmount,
		ci.accountnumber As CreditorAccountNumber,
		cr.Name As [Creditor Name]	
	FROM 
		tblTask t inner join
		tblMatterTask mt ON mt.TaskId = t.TaskId inner join
		tblMatter m ON m.MatterId = mt.MatterId and m.IsDeleted = 0 and m.MatterStatusId not in (2,4) inner join
		tblSettlements s ON s.MatterId = m.MatterId and s.Active = 1 inner join
		tblCreditorInstance ci ON ci.CreditorInstanceId = m.CreditorInstanceId inner join
		tblCreditor cr ON cr.CreditorId = ci.CreditorId inner join
		tblClient c ON c.ClientId = m.ClientId  and c.ClientId = @ClientId inner join
		tblPerson p ON p.PersonId = c.PrimaryPersonId  
	WHERE 
		t.TaskTypeId = 72 and (t.TaskResolutionId is null or t.TaskResolutionId not in  (1,2,3,4))
			
END

GO
 

