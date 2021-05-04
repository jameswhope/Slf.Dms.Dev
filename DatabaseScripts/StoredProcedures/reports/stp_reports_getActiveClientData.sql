IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_reports_getActiveClientData')
	BEGIN
		DROP  Procedure  stp_reports_getActiveClientData
	END

GO

CREATE procedure [dbo].[stp_reports_getActiveClientData]
as
BEGIN
	select
		[LawFirm] 
		, [State]
		, [Agency]
		, [AccountNumber] 
		, [Client Name] 
		, [Address] 
		, [City] 
		, [Zip] 
		, [Contact Info] = left([Contact Info],len([Contact Info])-1)
	from (
		select [LawFirm] = co.name, [State]= s.name, [Agency] = a.name, [AccountNumber] = c.accountnumber, [Client Name] = p.firstname + ' ' + p.lastname
		, [Address] = case when p.street2 is null then p.street else p.street + ', ' + p.street2 end, [City] = p.city, [Zip] = p.zipcode
		, [Contact Info] = isnull((select pt.name + ': (' + convert(varchar,isnull(areacode,'')) + ')' +  convert(varchar, case when not number is null then right(number,3) + '-' + left(number,4) else '' end ) + case when extension is null then '' else 'Ext: ' +convert(varchar,extension) end + ','
							 from tblPersonPhone pp inner join tblphone p on pp.phoneid = p.phoneid inner join tblPhoneType pt on pt.phonetypeid = p.phonetypeid
							 where pp.personid = c.primarypersonid FOR XML PATH('')),'NONE,')
		from tblclient c 
		inner join tblcompany co on c.companyid = co.companyid
		inner join tblperson p on p.personid = c.primarypersonid
		inner join tblstate s on s.stateid = p.stateid
		inner join tblagency a on a.agencyid = c.agencyid
		where not currentclientstatusid in (15,17,18)
		) as ClientData
	order by Lawfirm, [state], agency, [client name]
END


GRANT EXEC ON stp_reports_getActiveClientData TO PUBLIC



