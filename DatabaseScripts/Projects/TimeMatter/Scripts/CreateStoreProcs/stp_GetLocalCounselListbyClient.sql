set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure  [dbo].[stp_GetLocalCounselListbyClient]
(
	@ClientId int ,
	@ShowInhouse bit = 0	
)

AS


IF @ShowInhouse=1
BEGIN
SELECT  

*

from
(
select 

cstate.CompanyId,
--s.StateId,
--s.Abbreviation,
a.AttorneyId,
a.FirstName,
a.MiddleName,
a.LastName,
CASE WHEN a.MiddleName is NULL then a.FirstName+' '+a.LastName
	 WHEN a.MiddleName IN('',' ') then a.FirstName+' '+a.LastName
	 else a.FirstName +' '+ a.MiddleName +' '+a.LastName  end as LocalCounsel,
a.IsInhouse,
 'Firm: '+ ltrim(rtrim(IsNull(cstate.[Name],'')))+'<br>' +'ADDRESS: '+ ltrim(rtrim(IsNull(a.Address1,'')))+' '+ltrim(rtrim(IsNull(a.Address2,'')))+'<br>'+ltrim(rtrim(IsNull(a.City,'')))+'<br>'+ltrim(rtrim(IsNull(a.State,'')))+' '+ltrim(rtrim(IsNull(a.Zip,''))) +'<br>'+
'PHONE: '+ltrim(rtrim(Isnull(a.Phone1,'')))+' '+ltrim(rtrim(IsNull(a.Phone2,''))) +'<br>'+ 'EMAIL: '+ltrim(rtrim(IsNull(a.EmailAddress,''))) as Details



from 

tblAttyStates tas 
join tblState s  on s.Abbreviation= tas.State 
join tblAttorney a on a.AttorneyId = tas.AttorneyId and a.AttorneyID NOT IN (182,217)
join 
( select 
c.ClientId,
c.CompanyId,
p.StateId,
co.Name 

from dbo.tblClient c 
join dbo.tblPerson p on p.Personid=c.PrimaryPersonId
join dbo.tblCompany co on co.CompanyId =c.CompanyId
where c.ClientId =@ClientId
) cstate on cstate.StateId = s.StateId



UNION


SELECT 

0 as CompanyId,
a.AttorneyId,
a.FirstName,
a.MiddleName,
a.LastName,
CASE WHEN a.MiddleName is NULL then a.FirstName+' '+a.LastName
	 WHEN a.MiddleName IN('',' ') then a.FirstName+' '+a.LastName
	 else a.FirstName +' '+ a.MiddleName +' '+a.LastName  end as LocalCounsel
,a.IsInhouse, 'ADDRESS: '+ ltrim(rtrim(IsNull(a.Address1,'')))+' '+ltrim(rtrim(IsNull(a.Address2,'')))+'<br>'+ltrim(rtrim(IsNull(a.City,'')))+'<br>'+ltrim(rtrim(IsNull(a.State,'')))+' '+ltrim(rtrim(IsNull(a.Zip,''))) +'<br>'+
'PHONE: '+ltrim(rtrim(Isnull(a.Phone1,'')))+' '+ltrim(rtrim(IsNull(a.Phone2,''))) +'<br>'+ 'EMAIL: '+ltrim(rtrim(IsNull(a.EmailAddress,''))) as Details

from dbo.tblAttorney a where a.IsInhouse =1
)b

order by LocalCounsel


END

ELSE 

BEGIN


select 

cstate.CompanyId,
--s.StateId,
--s.Abbreviation,

a.AttorneyId,
a.FirstName,
a.MiddleName,
a.LastName,
CASE WHEN a.MiddleName is NULL then a.FirstName+' '+a.LastName
	 WHEN a.MiddleName IN('',' ') then a.FirstName+' '+a.LastName
	 else a.FirstName +' '+ a.MiddleName +' '+a.LastName  end as LocalCounsel,
a.IsInhouse,
 'Firm: '+ ltrim(rtrim(IsNull(cstate.[Name],'')))+'<br>' +'ADDRESS: '+ ltrim(rtrim(IsNull(a.Address1,'')))+' '+ltrim(rtrim(IsNull(a.Address2,'')))+'<br>'+ltrim(rtrim(IsNull(a.City,'')))+'<br>'+ltrim(rtrim(IsNull(a.State,'')))+' '+ltrim(rtrim(IsNull(a.Zip,''))) +'<br>'+
'PHONE: '+ltrim(rtrim(Isnull(a.Phone1,'')))+' '+ltrim(rtrim(IsNull(a.Phone2,''))) +'<br>'+ 'EMAIL: '+ltrim(rtrim(IsNull(a.EmailAddress,''))) as Details



from 

tblAttyStates tas 
join tblState s  on s.Abbreviation= tas.State 
join tblAttorney a on a.AttorneyId = tas.AttorneyId and a.AttorneyID NOT IN (182,217)
join 
( select 
c.ClientId,
c.CompanyId,
p.StateId,
co.Name 

from dbo.tblClient c 
join dbo.tblPerson p on p.Personid=c.PrimaryPersonId
join dbo.tblCompany co on co.CompanyId =c.CompanyId
where c.ClientId =@ClientId
) cstate on cstate.StateId = s.StateId

order by IsInhouse, (CASE WHEN a.MiddleName is NULL then a.FirstName+' '+a.LastName
	 WHEN a.MiddleName IN('',' ') then a.FirstName+' '+a.LastName
	 else a.FirstName +' '+ a.MiddleName +' '+a.LastName  end ) asc
 



END
















