IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_matters_getQuery')
	BEGIN
		DROP  Procedure  stp_matters_getQuery
	END

GO

create procedure stp_matters_getQuery
(
@page int,
@pagesize int
)
as
BEGIN
/*dev
declare @page int
declare @pagesize int

set @page = 3
set @pagesize = 50
*/
	select
	rowNum,MatterId,MatterNumber,MatterDate,MatterMemo,AttorneyId,AttorneyFirstName
	,AttorneyMiddleName,AttorneyLastName,AttorneyName,Address1,Address2,State,City,Phone1
	,EmailAddress,MatterStatusId,MatterStatus,MatterStatusDescr,MatterSubStatusId,MatterSubStatus
	,Companyid,CompanyName,ClientId,ClientAccountNumber,PrimaryPersonId,ClientFirstName,ClientLastName
	,ClientPrimaryApplicantName,PersonStateId,PersonState,CreditorInstanceid,Amount,[Creditor Account Status]
	from
	(
	select row_number() over(order by m.matterid)[rowNUm],
	m.MatterId,m.MatterNumber,m.MatterDate,m.MatterMemo,m.AttorneyId,
	a.FirstName[AttorneyFirstName],a.MiddleName[AttorneyMiddleName],a.LastName[AttorneyLastName],
	CASE WHEN m.AttorneyId is null then 'None'
		 WHEN m.AttorneyId = 0 then		'TBD'
		 ELSE a.FirstName +' '+IsNull(a.MiddleName+' ','')+a.LastName END as [AttorneyName],
	a.Address1,a.Address2,a.State,a.City,a.Phone1,a.EmailAddress,
	m.MatterStatusId,msc.MatterStatus,msc.MatterStatusDescr,mssc.MatterSubStatusId,mssc.MatterSubStatus,
	co.Companyid,co.Name [CompanyName],
	c.ClientId,c.AccountNumber as ClientAccountNumber,c.PrimaryPersonId,p.FirstName[ClientFirstName],
	p.LastName[ClientLastName],p.FirstName +' '+ p.LastName as[ClientPrimaryApplicantName],p.StateId [PersonStateId],
	s.Name as [PersonState],ci.CreditorInstanceid,ci.Amount,acctstat.[description]as[Creditor Account Status]
	from dbo.tblMatter m
	join dbo.tblClient c on c.ClientId=m.ClientId
	join dbo.tblPerson p on p.personId =c.PrimaryPersonId
	join dbo.tblMatterStatus msc on msc.MatterStatusId=m.MatterStatusId
	join dbo.tblMatterSubStatus mssc on mssc.MatterSubStatusId = m.MatterSubStatusId
	left outer join dbo.tblAttorney a on a.AttorneyId = m.AttorneyId
	join dbo.tblCreditorInstance ci on ci.CreditorInstanceId = m.CreditorInstanceid
	inner join tblaccount acct with(nolock) on acct.accountid = ci.accountid
	inner join tblaccountstatus acctstat with(nolock) on acctstat.AccountStatusID = acct.AccountStatusID
	left join dbo.tblState s on s.StateId =p.StateId
	left join dbo.tblState t on t.name = a.State
	join dbo.tblCompany co on co.CompanyId =c.Companyid
	Where IsNull(m.IsDeleted,0)=0
	) as tdata
	where rowNum between (@page*@pageSize)-@pageSize and (@page*@pageSize)-1
	option (fast 5)

END


GRANT EXEC ON stp_matters_getQuery TO PUBLIC

GO


