IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ClientFile_getClientInfo')
	BEGIN
		DROP  Procedure  stp_ClientFile_getClientInfo
	END

GO

CREATE procedure [dbo].[stp_ClientFile_getClientInfo]
(
	@clientID int
)
as
BEGIN

	/*development
	declare @clientID int
	set @clientID = 88733
	*/

		select PrimaryOrder,Relationship,Name,Gender,SSN,Address,[ContactInfo] = left(ContactInfo,len(ContactInfo)-1)
from
(
SELECT 
	case when p.relationship = 'Prime' then 1 else 0 end as PrimaryOrder
	, isnull(p.relationship,'') as [Relationship]
	, p.FirstName + ' ' + p.LastName AS [Name]
	, isnull(p.gender,'') as [Gender]
	, isnull(p.SSN,'') as [SSN]
	, case when p.street2 is null then isnull(p.Street,'') + char(13) else isnull(p.Street,'') + char(13) + isnull(p.Street2,'') + char(13) end 
	+ isnull(case when p.stateid  = 0 then p.City + p.ZipCode else p.City + ', ' + s.Abbreviation + ' ' + p.ZipCode end,'')
	as Address
	,(select pt.name + ': (' + convert(varchar,isnull(areacode,'')) + ')' +  convert(varchar, case when not number is null then right(number,3) + '-' + left(number,4) else '' end ) + case when extension is null then '' else 'Ext: ' +convert(varchar,extension) end + ','
from tblPersonPhone pp inner join tblphone p on pp.phoneid = p.phoneid inner join tblPhoneType pt on pt.phonetypeid = p.phonetypeid
where pp.personid = c.primarypersonid FOR XML PATH('') )[ContactInfo]
FROM tblClient AS c 
	INNER JOIN tblPerson AS p ON c.ClientID = p.ClientID 
	LEFT OUTER JOIN tblState AS s ON p.StateID = s.StateID 
WHERE
	(c.ClientID = @clientID) 
) as cData
order by PrimaryOrder desc

END

GRANT EXEC ON stp_ClientFile_getClientInfo TO PUBLIC



