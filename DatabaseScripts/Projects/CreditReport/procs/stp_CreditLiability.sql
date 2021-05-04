if exists (select * from sysobjects where name = 'stp_CreditLiability')
	drop procedure stp_CreditLiability
go

create procedure stp_CreditLiability
(
	@creditliabilityid int
)
as


select 
	f.creditliabilityid, 
	isnull(f.originalcreditor,'') [originalcreditor], 
	isnull(g.name,l.creditorname) [currentcreditor], 
	isnull(l.creditorid,-9) [creditorid], 
	isnull(g.creditorgroupid,-9) [creditorgroupid],
	f.accountnumber,
	f.unpaidbalance [originalamount], 
	f.unpaidbalance [currentamount],
	isnull(c.street,l.street) [street], 
	isnull(c.street2,'') [street2], 
	isnull(c.city,l.city) [city], 
	isnull(c.stateid,isnull(s.stateid,0)) [stateid],
	isnull(c.zipcode,l.postalcode) [zipcode]
from vw_CreditLiabilitiesFiltered f
join tblcreditliabilitylookup l on l.creditliabilitylookupid = f.creditliabilitylookupid
left join tblcreditor c on c.creditorid = l.creditorid
left join tblcreditorgroup g on g.creditorgroupid = c.creditorgroupid
left join tblstate s on s.abbreviation = l.statecode
where f.creditliabilityid = @creditliabilityid

