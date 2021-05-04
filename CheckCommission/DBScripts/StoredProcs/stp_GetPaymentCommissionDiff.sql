IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetPaymentCommissionDiff')
	BEGIN
		DROP  Procedure  stp_GetPaymentCommissionDiff 
	END

GO

CREATE PROCEDURE stp_GetPaymentCommissionDiff 
@StartDate DateTime = NULL,
@EndDate DateTime = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
select 
	r.ClientId AS [Client Id],
	c.AgencyId AS [Agency Id],
	p.RegisterPaymentId AS [Payment Id],
	p.PaymentDate AS [Payment Date],
	r.RegisterId AS [Fee Id],
	r.EntryTypeId AS [Fee Type],
	round(isnull(p.amount, 0),2) AS [Amount Paid], 
	round(coalesce(sum(cp.amount), 0),2) AS [Commission Paid]
from
	tblRegisterPayment p
Inner join tblRegister r on (r.RegisterId = p.FeeRegisterId)
Inner join tblClientId c on (c.clientid = r.clientid)
Left join tblCommpay cp on (cp.RegisterPaymentId = p.RegisterPaymentId)
where
	p.voided = 0 and
	p.bounced = 0 and
	p.PaymentDate Between IsNull(@StartDate, Cast('1900-01-01' AS DATETIME)) and IsNull(@EndDate, GetDate())
Group by r.ClientId, c.AgencyId, p.RegisterPaymentId, p.PaymentDate, r.RegisterId, r.EntryTypeId, isnull(p.amount, 0)
Having round(isnull(p.amount, 0),2) <> round(coalesce(sum(cp.amount), 0),2)
Order By r.Clientid, p.RegisterPaymentId
END

GO
