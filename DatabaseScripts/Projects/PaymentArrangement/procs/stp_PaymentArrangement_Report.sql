IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PaymentArrangement_Report')
	BEGIN
		DROP  Procedure  stp_PaymentArrangement_Report
	END

GO

CREATE Procedure [dbo].[stp_PaymentArrangement_Report]
@PaymentDateFrom datetime = null,
@PaymentDateTo datetime = null,
@CompanyId int = null
AS
SELECT
ps.PmtScheduleID,     
ps.PmtAmount as CheckAmount,
ps.PmtDate as DueDate,
ps.ClientID, 
c.AccountNumber,
ps.AccountID,
'***' + right(ci.AccountNumber,4) [Last4],
p.FirstName + ' ' + p.LastName AS ClientName, 
cp.ShortCoName as Firm,
cc.Name AS CurrentCreditor, 
ps.PmtRecdDate,
ps.SettlementID,  
s.SettlementAmount, 
s.SettlementDueDate,
ps.Created, 
ps.CreatedBy, 
cu.FirstName + ' ' + cu.LastName AS CreatedByName, 
ps.LastModified, ps.LastModifiedBy, 
mu.FirstName + ' ' + mu.LastName AS LastModifedByName,
c.AvailableSDA - dbo.udf_FundsOnHold(s.ClientID,s.SettlementID) [AvailableSDA],
case when s.SettlementAmount = 0 then 0 else (ps.PmtAmount/s.SettlementAmount)*s.SettlementFee end [SettlementFee],
c.OvernightDeliveryFee
FROM 
tblCreditor AS cc WITH (NOLOCK) INNER JOIN
tblCreditorInstance AS ci WITH (NOLOCK) ON cc.CreditorID = ci.CreditorID INNER JOIN
tblPaymentSchedule AS ps WITH (NOLOCK) INNER JOIN
tblUser AS cu WITH (NOLOCK) ON ps.CreatedBy = cu.UserID INNER JOIN
tblUser AS mu WITH (NOLOCK) ON ps.LastModifiedBy = mu.UserID INNER JOIN
tblClient AS c WITH (NOLOCK) ON ps.ClientID = c.ClientID INNER JOIN
tblCompany cp WITH (NOLOCK) ON c.CompanyID = cp.CompanyID INNER JOIN
tblPerson AS p WITH (NOLOCK) ON c.PrimaryPersonID = p.PersonID INNER JOIN
tblAccount AS a WITH (NOLOCK) ON ps.AccountID = a.AccountID ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID INNER JOIN
tblSettlements AS s ON ps.SettlementID = s.SettlementID
Where 
(@Companyid is null or c.companyid = @Companyid)
and (ps.PmtDate between isnull(@PaymentDateFrom,'2011-12-01') and isnull(@PaymentDateTo, GetDate()) )




GO


GRANT EXEC ON stp_PaymentArrangement_Report TO PUBLIC

GO


