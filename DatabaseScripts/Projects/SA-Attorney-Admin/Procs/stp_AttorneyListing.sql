if exists (select * from sysobjects where name = 'stp_AttorneyListing')
	drop procedure stp_AttorneyListing
go

create procedure stp_AttorneyListing
(
	@CompanyID int
,	@Where varchar(2000) = ''
)
as 
begin
/*
	History:
	jhernandez		12/04/07		Created.
	jhernandez		03/04/08		Added FullName
	jhernandez		03/05/08		Added optional search criteria
*/

exec('
select
  a.AttorneyID
, a.FirstName
, isnull(a.MiddleName, '''') as MiddleName
, a.LastName
, isnull(a.Suffix, '''') as Suffix
, isnull(a.UserID, -1) [UserID]
, case when r.AttyPivotID > 0 then ''true'' else ''false'' end [Associated]
, isnull(r.AttyRelation, '''') as Relation 
, a.LastName + '', '' + a.FirstName + '' '' + isnull(a.MiddleName, '''') as [FullName]
from
 tblAttorney a 
left join tblAttyRelation r 
 on r.AttorneyID = a.AttorneyID 
  and r.CompanyID = ' + @CompanyID + '
left join tblAttorneyType t
 on t.Type = r.AttyRelation ' 
+ @Where + '
order by
 a.LastName, a.FirstName
')

end