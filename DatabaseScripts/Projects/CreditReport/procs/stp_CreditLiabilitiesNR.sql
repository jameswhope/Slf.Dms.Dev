if exists (select * from sysobjects where name = 'stp_CreditLiabilitiesNR')
	drop procedure stp_CreditLiabilitiesNR
go

create procedure stp_CreditLiabilitiesNR
(
	@clientid int
)
as


select f.creditliabilityid, case when f.originalcreditor = '' then NULL else f.originalcreditor end [originalcreditor], isnull(g.name,c.creditorname) [currentcreditor], c.creditorid, '***' + right(f.accountnumber,4) [last4],
	f.unpaidbalance [originalamount], f.unpaidbalance [currentamount]
from vw_CreditLiabilitiesFiltered f
join vw_leadapplicant_client lc on lc.leadapplicantid = f.leadapplicantid
	and lc.clientid = @clientid
join tblcreditliabilitylookup c on c.creditliabilitylookupid = f.creditliabilitylookupid
left join tblcreditor cr on cr.creditorid = c.creditorid
left join tblcreditorgroup g on g.creditorgroupid = cr.creditorgroupid
where f.dateimported is null
order by f.originalcreditor, [currentcreditor]
 