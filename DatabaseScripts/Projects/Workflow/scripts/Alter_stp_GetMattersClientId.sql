IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetMattersClientId')
	BEGIN
		DROP  Procedure  stp_GetMattersClientId
	END

GO

CREATE Procedure stp_GetMattersClientId
(
	@ClientId int,
	@returntop varchar (50) = '100 percent',
	@OrderBy  varchar (50) = 'order by MatterDate desc,MatterNumber desc',
	@OpenOnly bit = 0
)
AS

BEGIN
/*
if @returntop='100 percent' 
begin

select 
mt.MatterTypeCode, m.MatterTypeId, IsNull(ci.Accountid,0) as AccountId, 
IsNull(ci.CreditorInstanceId,0) as CreditorInstanceID,
m.MatterId,
MatterDate,
MatterNumber,
MatterMemo,
c.ClientId,
c.AccountNumber,
CASE WHEN m.CreditorInstanceId is null then 'None'
     WHEN m.CreditorInstanceid=0 then 'TBD'
	 ELSE '***'+ RIGHT(ci.AccountNumber,4)  END as CIAccountNumber,
p.FirstName+' '+ p.LastName as ClientName,
CASE WHEN m.creditorinstanceid is null THEN  'None'
	 WHEN m.creditorinstanceid = 0 THEN		 'TBD'
	 ELSE cred.Name END as [Name],
co.[Name] as Firm,

CASE WHEN m.AttorneyId is null then 'None'
	 WHEN m.AttorneyId = 0 then		'TBD'
	 ELSE at.FirstName+' '+ at.LastName END as Attorney,
msc.MatterStatusCodeId,
--msc.MatterStatusCode, 
ms.MatterStatusId,
ms.MatterStatus as MatterStatusCode, 
m.MatterSubStatusId, 
(select MatterSubStatus from tblmattersubstatus where mattersubstatusid=m.MatterSubStatusId) as MatterSubStatus,
mt.MatterGroupId

from 

dbo.tblMatter m
join dbo.tblClient c on c.ClientId=m.ClientId
join dbo.tblPerson p on c.PrimaryPersonId =p.PersonId
join dbo.tblCompany co on co.CompanyId=c.CompanyId
join dbo.tblMatterStatusCode as msc on msc.MatterStatusCodeId = m.MatterStatusCodeId
left outer join dbo.tblAttorney at on at.AttorneyId = m.AttorneyId
left outer join tblMatterType mt on mt.MatterTypeId = m.mattertypeid
left outer join tblCreditorInstance ci on ci.creditorinstanceid=m.creditorinstanceid
left outer join dbo.tblMatterStatus as ms on ms.MatterStatusId = m.MatterStatusId
left outer join dbo.tblCreditor cred on cred.CreditorId = ci.CreditorId

where c.ClientId = @ClientId and IsNull(m.IsDeleted,0)=0

order by MatterDate desc,MatterNumber desc

end
else
begin*/
declare @where varchar(255);
if @OpenOnly = 1 begin
	set @where = 'and m.MatterStatusId not in (2,4)';
end
else begin 
	set @where = '';
end
if @returntop = '100 percent'
set @returntop =''
else
set @returntop ='top '+@returntop


exec
(
'select  ' + @returntop + '

mt.MatterTypeCode, m.MatterTypeId, IsNull(ci.Accountid,0) as AccountId, 
IsNull(ci.CreditorInstanceId,0) as CreditorInstanceID,
m.MatterId,
MatterDate,
MatterNumber,
MatterMemo,
c.ClientId,
c.AccountNumber,
CASE WHEN m.CreditorInstanceId is null then ''None''
     WHEN m.CreditorInstanceid=0 then ''TBD''
	 ELSE ''***''+ RIGHT(ci.AccountNumber,4)  END as CIAccountNumber,
p.FirstName+'' ''+ p.LastName as ClientName,
CASE WHEN m.creditorinstanceid is null THEN  ''None''
	 WHEN m.creditorinstanceid = 0 THEN		 ''TBD''
	 ELSE cred.Name END as [Name],
co.[Name] as Firm,
CASE WHEN m.AttorneyId is null then ''None''
	 WHEN m.AttorneyId = 0 then		''TBD''
	 ELSE at.FirstName+'' ''+ at.LastName END as Attorney,
msc.MatterStatusCodeId,
--msc.MatterStatusCode, 
ms.MatterStatusId,
ms.MatterStatus as MatterStatusCode, 
m.MatterSubStatusId, 
(select MatterSubStatus from tblmattersubstatus WITH(NOLOCK) where mattersubstatusid=m.MatterSubStatusId) as MatterSubStatus,
mt.MatterGroupId

from 

dbo.tblMatter m WITH(NOLOCK)
join dbo.tblClient c WITH(NOLOCK) on c.ClientId=m.ClientId
join dbo.tblPerson p WITH(NOLOCK) on c.PrimaryPersonId =p.PersonId
join dbo.tblCompany co WITH(NOLOCK) on co.CompanyId=c.CompanyId
join dbo.tblMatterStatusCode as msc WITH(NOLOCK) on msc.MatterStatusCodeId = m.MatterStatusCodeId
left outer join dbo.tblAttorney at WITH(NOLOCK) on at.AttorneyId = m.AttorneyId
left outer join tblMatterType mt WITH(NOLOCK) on mt.MatterTypeId = m.mattertypeid
left outer join tblCreditorInstance ci WITH(NOLOCK) on ci.creditorinstanceid=m.creditorinstanceid
left outer join dbo.tblMatterStatus as ms WITH(NOLOCK) on ms.MatterStatusId = m.MatterStatusId
left outer join dbo.tblCreditor cred WITH(NOLOCK) on cred.CreditorId = ci.CreditorId
left JOIN tblsettlements s WITH(NOLOCK) on s.matterid=m.MatterId 
where c.ClientId = ' + @ClientId + ' and IsNull(m.IsDeleted,0)=0 and (CASE when m.MatterTypeId=3 then s.Active else 1 end) = 1 '
+  @OrderBy )
--order by MatterDate desc,MatterNumber desc ')

end
GO



