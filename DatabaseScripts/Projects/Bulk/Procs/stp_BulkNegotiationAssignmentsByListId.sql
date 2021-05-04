IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_BulkNegotiationAssignmentsByListID')
	BEGIN
		DROP  Procedure  stp_BulkNegotiationAssignmentsByListID
	END

GO

CREATE Procedure stp_BulkNegotiationAssignmentsByListID 
(
	@BulkListID int
)
as
begin
/*
	History:
	jhernandez		05/05/08		
	jhernandez		05/08/08		Add required fields to template if list has been published.
									These fields are not necessarily missing, they just werent added
									when the list was built originally.
	opereira		05/12/08		Retrieve all fields.
	opereira		08/22/08		Use static fields and not dynamic fields
*/

select  b.ListName, 
		c.AccountNUmber as [SDAAccount], 
		p.FirstName as [ApplicantFirstName], 
		p.LastName as [ApplicantLastName], 
		p.SSN as [SSN],
		ci.AccountNumber as [CurrentCreditorAccountNumber], 
		CONVERT(varchar, a.CurrentAmount) as [CurrentAmount], 
		c.SDABalance - c.PFOBalance -
			  (SELECT     ISNULL(SUM(r.Amount), 0)
				FROM         tblRegister r
				WHERE      (r.ClientId = c.ClientID) AND (r.EntryTypeId = 3) AND (r.Hold > GETDATE()) AND (r.Void IS NULL) AND (r.Bounce IS NULL) AND (r.Clear IS NULL)) 
		  -
			  (SELECT     ISNULL(SUM(Amount), 0) 
				FROM          dbo.tblRegister AS r1
				WHERE      (r1.ClientId = c.ClientID) AND (r1.EntryTypeId = 43) AND (r1.Hold > GETDATE()) AND (r1.Void IS NULL) AND (r1.Bounce IS NULL) AND (r1.Clear IS NULL)) 
		AS FundsAvailable,
		a.AccountId as [AccountId], 
		co.FirstName as [CoAppFirstName],
		co.LastName as [CoAppLastName], 
		co.SSN as [CoAppSSN], 
		x.Notes as [Notes], 
		x.LastOfferMade as [LastOfferMade], 
		x.LastOfferReceived as [LastOfferReceived], 
		(select top 1 om.SettlementAmount 
		 from tblSettlements om
		 where om.status = 'R' and om.ClientId = c.ClientId and om.CreditorAccountId = a.AccountId
		 order by om.SettlementId Desc) as [LastRejectedOffer],
		 (select top 1  od.OfferDirection 
		 from tblSettlements od
		 where od.status = 'R' and od.ClientId = c.ClientId and od.CreditorAccountId = a.AccountId
		 order by od.SettlementId Desc) as [LastRejectedOfferDirection]
from tblAccount a
inner join tblBulkNegotiationListXref x on x.AccountID = a.AccountID
inner join tblBulkNegotiationLists b on b.BulkListID = x.BulkListID and b.BulkListID = @BulkListID 
inner join tblClient c on c.ClientID = a.ClientID and c.CurrentClientStatusID not in (15, 16, 17, 18)
inner join tblPerson p on p.PersonID = c.PrimaryPersonID
inner join tblCreditorInstance as ci on ci.CreditorInstanceID = a.CurrentCreditorInstanceID
left join vwFirstCoApplicant co on c.clientid = co.clientid
where c.currentclientstatusid not in (15,17,18)

end

go