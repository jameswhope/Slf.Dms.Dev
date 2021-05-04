IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CheckScan_ClientSearch')
	BEGIN
		DROP  Procedure  stp_CheckScan_ClientSearch
	END

GO

Create procedure [dbo].[stp_CheckScan_ClientSearch]
(
	@searchterm varchar(max)
)
as
BEGIN
--	declare @searchterm varchar(max)
--	set @searchterm = '600500' 
	set @searchterm ='%' + @searchterm + '%'

	select 
		PrimaryOrder
		,Relationship
		,AccountNumber
		,clientid
		,Name
		,Gender
		,SSN
		,Address
		,[ContactInfo] = left(ContactInfo,len(ContactInfo)-1)
		, [NumCoApps] = case when PrimaryOrder = 1 then (select count(personid) from tblperson where clientid = cdata.clientid)-1 else 0 end
	from
		(
			SELECT 
				[PrimaryOrder] = case when p.relationship = 'Prime' then 1 else 0 end 
				, [accountnumber] = c.accountnumber
				, c.clientid
				, [Relationship] = isnull(p.relationship,'') 
				, [Name] = p.FirstName + ' ' + p.LastName 
				, [Gender] = isnull(p.gender,'')
				, [SSN] = isnull(p.SSN,'')
				, [Address] = case when p.street2 is null then isnull(p.Street,'') + char(13) else isnull(p.Street,'') + char(13) + isnull(p.Street2,'') + char(13) end 
				+ isnull(case when p.stateid  = 0 then p.City + p.ZipCode else p.City + ', ' + s.Abbreviation + ' ' + p.ZipCode end,'')
				, [ContactInfo] = (select pt.name + ': (' + convert(varchar,isnull(areacode,'')) + ')' +  convert(varchar, case when not number is null then right(number,3) + '-' + left(number,4) else '' end ) + case when extension is null then '' else 'Ext: ' +convert(varchar,extension) end + ','
					from tblPersonPhone pp inner join tblphone p on pp.phoneid = p.phoneid inner join tblPhoneType pt on pt.phonetypeid = p.phonetypeid
					where pp.personid = c.primarypersonid FOR XML PATH(''))
			FROM tblClient AS c 
				INNER JOIN tblPerson AS p ON c.ClientID = p.ClientID 
				LEFT OUTER JOIN tblState AS s ON p.StateID = s.StateID 
			where 
				c.accountnumber like @searchterm 
				or p.ssn like @searchterm
				or p.lastname like @searchterm
				or p.firstname + ' ' + p.lastname like @searchterm
				or p.street like @searchterm
		) as cData
	order by 
		 Name , PrimaryOrder desc
END

GRANT EXEC ON stp_CheckScan_ClientSearch TO PUBLIC


