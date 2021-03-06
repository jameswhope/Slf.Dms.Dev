set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

/*
	Revision	: <04 - 24 February 2010>
	Category	: [TimeMatter]
	Type        : {New}
	Decription	: Returns Valid Local Counsel addflag to show in house attorney
*/



CREATE procedure  [dbo].[stp_GetLocalCounselListbyClient]
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
ar.CompanyId,
a.AttorneyId,
a.FirstName,
a.MiddleName,
a.LastName,
CASE WHEN a.MiddleName is NULL then a.FirstName+' '+a.LastName
	 WHEN a.MiddleName IN('',' ') then a.FirstName+' '+a.LastName
	 else a.FirstName +' '+ a.MiddleName +' '+a.LastName  end as LocalCounsel
,a.IsInhouse, 'Firm: '+ ltrim(rtrim(IsNull(co.[Name],'')))+'<br>' +'ADDRESS: '+ ltrim(rtrim(IsNull(a.Address1,'')))+' '+ltrim(rtrim(IsNull(a.Address2,'')))+'<br>'+ltrim(rtrim(IsNull(a.City,'')))+'<br>'+ltrim(rtrim(IsNull(a.State,'')))+' '+ltrim(rtrim(IsNull(a.Zip,''))) +'<br>'+
'PHONE: '+ltrim(rtrim(Isnull(a.Phone1,'')))+' '+ltrim(rtrim(IsNull(a.Phone2,''))) +'<br>'+ 'EMAIL: '+ltrim(rtrim(IsNull(a.EmailAddress,''))) as Details
--,*
from 
dbo.tblAttyStates tas
join dbo.tblAttorney a on a.AttorneyId=tas.AttorneyId
join dbo.tblAttyRelation ar on ar.AttorneyId=a.AttorneyId
join dbo.tblClient c on ar.CompanyId=c.CompanyId
join dbo.tblPerson p on p.PersonId=c.PrimaryPersonId
join dbo.tblState s on s.StateID=p.StateId
left outer join tblCompany co on ar.companyid=co.companyId

where 
s.Abbreviation =tas.State and c.ClientId=@ClientId

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

--order by IsInhouse, (CASE WHEN a.MiddleName is NULL then a.FirstName+' '+a.LastName
--	 WHEN a.MiddleName IN('',' ') then a.FirstName+' '+a.LastName
--	 else a.FirstName +' '+ a.MiddleName +' '+a.LastName  end ) asc
END

ELSE 

BEGIN


select 
ar.CompanyId,
a.AttorneyId,
a.FirstName,
a.MiddleName,
a.LastName,
CASE WHEN a.MiddleName is NULL then a.FirstName+' '+a.LastName
	 WHEN a.MiddleName IN('',' ') then a.FirstName+' '+a.LastName
	 else a.FirstName +' '+ a.MiddleName +' '+a.LastName  end as LocalCounsel
,a.IsInhouse, 'Firm: '+ ltrim(rtrim(IsNull(co.[Name],'')))+'<br>' +'ADDRESS: '+ ltrim(rtrim(IsNull(a.Address1,'')))+' '+ltrim(rtrim(IsNull(a.Address2,'')))+'<br>'+ltrim(rtrim(IsNull(a.City,'')))+'<br>'+ltrim(rtrim(IsNull(a.State,'')))+' '+ltrim(rtrim(IsNull(a.Zip,''))) +'<br>'+
'PHONE: '+ltrim(rtrim(Isnull(a.Phone1,'')))+' '+ltrim(rtrim(IsNull(a.Phone2,''))) +'<br>'+ 'EMAIL: '+ltrim(rtrim(IsNull(a.EmailAddress,''))) as Details
--,*
from 
dbo.tblAttyStates tas
join dbo.tblAttorney a on a.AttorneyId=tas.AttorneyId
join dbo.tblAttyRelation ar on ar.AttorneyId=a.AttorneyId
join dbo.tblClient c on ar.CompanyId=c.CompanyId
join dbo.tblPerson p on p.PersonId=c.PrimaryPersonId
join dbo.tblState s on s.StateID=p.StateId
left outer join tblCompany co on ar.companyid=co.companyId

where 
s.Abbreviation =tas.State and c.ClientId=@ClientId
order by IsInhouse, (CASE WHEN a.MiddleName is NULL then a.FirstName+' '+a.LastName
	 WHEN a.MiddleName IN('',' ') then a.FirstName+' '+a.LastName
	 else a.FirstName +' '+ a.MiddleName +' '+a.LastName  end ) asc


END















