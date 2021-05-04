if exists (select * from sysobjects where name = 'stp_GetFilteredCreditLiabilities')
	drop procedure stp_GetFilteredCreditLiabilities
go

create procedure stp_GetFilteredCreditLiabilities
(
	@ReportID as integer
)
as
begin
/*
	7/12/2010 - Optimized for performance. For some reason the left join to tblState started killing this query.
*/

	select l.*, s.firstname, c.*, st.stateid, s.coborrower
	from vw_CreditLiabilitiesFiltered l 
	join tblcreditsource s on s.creditsourceid = l.creditsourceid 
	join tblcreditliabilitylookup c on c.creditliabilitylookupid = l.creditliabilitylookupid and c.statecode <> ''
	join tblstate st on st.abbreviation = c.statecode
	where l.reportid = @ReportID 
	
	union all 

	select l.*, s.firstname, c.*, -1 [stateid], s.coborrower
	from vw_CreditLiabilitiesFiltered l 
	join tblcreditsource s on s.creditsourceid = l.creditsourceid 
	join tblcreditliabilitylookup c on c.creditliabilitylookupid = l.creditliabilitylookupid and c.statecode = ''
	where l.reportid = @ReportID 

	order by s.coborrower, s.firstname, c.creditorname

end
go 