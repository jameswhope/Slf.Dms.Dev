
alter Procedure [dbo].[stp_GetDisbursementTransactions]
(
	@StartDate datetime = null,
	@EndDate datetime = null,
	@CompanyId int = null
)
AS
Begin

Select
	r.RegisterId,
	isnull(e.Name, 'Other') [Type],
	c.AccountNumber,
	c.ClientId,
	p.FirstName + ' ' + p.LastName [ClientName],
	abs(r.Amount) [Amount],
	r.Created,
	Case When r.Void is not null Then 'X' else '' End [Voided],
	Case When r.Void is null Then '' else Convert(varchar, r.Void, 101) End [DateVoided],
	case when vc.converted is null then co.Name -- current
		 when vc.converted > r.created then cc.name
		 else co.Name -- current
	end [Company],
	case when vt.converted is null then t.displayname -- current
		 when vt.converted > r.created then tc.displayname
		 else t.displayname -- current
	end [Trust]
From tblRegister r 
join tblEntryType e on r.EntryTypeId = e.EntryTypeID and e.entrytypeid in (18,21,28,48)
join tblClient c on r.ClientId = c.ClientId
join tblPerson p on p.ClientId = c.ClientId and (p.Relationship = 'prime')
join tblCompany co on co.CompanyId = c.CompanyId
join tblTrust t on t.trustid = c.trustid
left join vw_ClientTrustConvDate vt on vt.clientid = c.clientid
left join tblTrust tc on tc.trustid = vt.origtrustid
left join vw_ClientCompanyConvDate vc on vc.clientid = c.clientid
left join tblCompany cc on cc.companyid = vc.origcompanyid
Where (@CompanyId is null or c.CompanyId = @CompanyId) 
And (@StartDate is null or r.Created >= @StartDate)
And (@EndDate is null or r.Created < @EndDate) 
Order By r.RegisterId

End 