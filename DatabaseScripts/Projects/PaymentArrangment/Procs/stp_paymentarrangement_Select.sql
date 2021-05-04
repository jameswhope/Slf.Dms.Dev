IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_paymentarrangement_Select')
	BEGIN
		DROP  Procedure  stp_paymentarrangement_Select
	END

GO

create procedure stp_paymentarrangement_Select
(
@settlementid			int = -1
)
as
BEGIN
SELECT     ps.PmtScheduleID, ps.ClientID, p.FirstName + ' ' + p.LastName AS ClientName, ps.AccountID, ps.SettlementID, ps.PmtDate, ps.PmtAmount, ps.PmtRecdDate, 
                      ps.Created, ps.CreatedBy, cu.FirstName + ' ' + cu.LastName AS CreatedByName, ps.LastModified, ps.LastModifiedBy, 
                      mu.FirstName + ' ' + mu.LastName AS LastModifedByName, cc.Name AS CurrentCreditor, ci.Amount, ci.OriginalAmount, ci.AccountNumber, ci.ReferenceNumber, 
                      oc.Name AS OriginalCreditor, s.SettlementAmount, s.SettlementDueDate
FROM         tblCreditor AS cc WITH (NOLOCK) INNER JOIN
                      tblCreditorInstance AS ci WITH (NOLOCK) ON cc.CreditorID = ci.CreditorID INNER JOIN
                      tblPaymentSchedule AS ps WITH (NOLOCK) INNER JOIN
                      tblUser AS cu WITH (NOLOCK) ON ps.CreatedBy = cu.UserID INNER JOIN
                      tblUser AS mu WITH (NOLOCK) ON ps.LastModifiedBy = mu.UserID INNER JOIN
                      tblClient AS c WITH (NOLOCK) ON ps.ClientID = c.ClientID INNER JOIN
                      tblPerson AS p WITH (NOLOCK) ON c.PrimaryPersonID = p.PersonID INNER JOIN
                      tblAccount AS a WITH (NOLOCK) ON ps.AccountID = a.AccountID ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID INNER JOIN
                      tblCreditor AS oc WITH (NOLOCK) ON ci.ForCreditorID = oc.CreditorID INNER JOIN
                      tblSettlements AS s ON ps.SettlementID = s.SettlementID
	WHERE
		(ps.Settlementid = @settlementid)
end


GO


GRANT EXEC ON stp_paymentarrangement_Select TO PUBLIC

GO


