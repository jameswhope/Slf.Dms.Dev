IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_paymentarrangement_Select]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_paymentarrangement_Select]
GO

create procedure [dbo].[stp_paymentarrangement_Select]
(
@settlementid			int = -1
)
as
BEGIN
	SELECT
	 ROW_NUMBER() OVER(ORDER BY ps.PmtDate, ps.PmtScheduleID) AS PaymentNumber
	 , ps.PmtScheduleID
	 , ps.ClientID
	 , p.FirstName + ' ' + p.LastName AS ClientName
	 , ps.AccountID
	 , ps.SettlementID
	 , ps.PmtDate
	 , ps.PmtAmount
	 , ps.PmtRecdDate
	 , ps.Created
	 , ps.CreatedBy
	 , cu.FirstName + ' ' + cu.LastName AS CreatedByName
	 , ps.LastModified
	 , ps.LastModifiedBy
	 , mu.FirstName + ' ' + mu.LastName AS LastModifedByName
	 , cc.Name AS CurrentCreditor
	 , ci.Amount
	 , ci.OriginalAmount
	 , ci.AccountNumber
	 , ci.ReferenceNumber
	 , oc.Name AS OriginalCreditor
	 , s.SettlementAmount
	 , s.SettlementDueDate
FROM
	tblCreditor AS cc WITH (NOLOCK)
	INNER JOIN
		tblCreditorInstance AS ci WITH (NOLOCK)
		ON cc.CreditorID = ci.CreditorID
	INNER JOIN
		tblPaymentSchedule AS ps WITH (NOLOCK)
	INNER JOIN
		tblUser AS cu WITH (NOLOCK)
		ON ps.CreatedBy = cu.UserID
	INNER JOIN
		tblUser AS mu WITH (NOLOCK)
		ON ps.LastModifiedBy = mu.UserID
	INNER JOIN
		tblClient AS c WITH (NOLOCK)
		ON ps.ClientID = c.ClientID
	INNER JOIN
		tblPerson AS p WITH (NOLOCK)
		ON c.PrimaryPersonID = p.PersonID
	inner JOIN
		tblAccount AS a WITH (NOLOCK)
		ON ps.AccountID = a.AccountID
		ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID
	left JOIN
		tblCreditor AS oc WITH (NOLOCK)
		ON ci.ForCreditorID = oc.CreditorID
	inner JOIN
		tblSettlements AS s
		ON ps.SettlementID = s.SettlementID
WHERE
	(ps.SettlementID = @settlementid) 
Order BY 1

end



GO

