IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetDisbursementTransactions')
	BEGIN
		DROP  Procedure  stp_GetDisbursementTransactions
	END

GO

CREATE Procedure stp_GetDisbursementTransactions
@StartDate datetime = null,
@EndDate datetime = null,
@CompanyId int = null
AS
Begin

--Works for Checksite only.
Select distinct 
nr.nachaRegisterId,
nr.RegisterId,
isnull(e.Name, 'Other') [Type],
nr.ShadowStoreId,
c.ClientId,
p.FirstName + ' ' + p.LastName [ClientName],
abs(nr.Amount) [Amount],
nr.Created,
Case When nr.NachaFileId > 0 Then 'Yes' else 'No' End [Sent],
Case When nf.DateSent is null Then '' Else Convert(varchar, nf.DateSent, 101) End [SentDate],
Case When r.Void is not null Then 'Yes' else 'No' End [Voided],
Case When r.Void is null Then '' else Convert(varchar, r.Void, 101) End [DateVoided],
nr.Flow,
co.Name [Company],
nr.Status,
nr.State,
nr.ReceivedDate,
nr.ProcessedDate   
From tblNachaRegister2 nr
join tblRegister r on nr.RegisterId = r.RegisterId
left join tblEntryType e on r.EntryTypeId = e.EntryTypeID
left join tblNachaFile nf on nf.NachaFileId = nr.NachaFileId
join tblClient c on r.ClientId = c.ClientId
join tblPerson p on p.ClientId = c.ClientId and (p.Relationship = 'prime')
join tblCompany co on co.CompanyId = c.CompanyId
Where nr.TrustId = 23 
And (@CompanyId is null or nr.CompanyId = @CompanyId) 
And (@StartDate is null or nr.Created >= @StartDate)
And (@EndDate is null or nr.Created < @EndDate) 
Order By nr.nachaRegisterId

End
GO



