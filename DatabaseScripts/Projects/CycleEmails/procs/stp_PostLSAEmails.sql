if exists (select 1 from sysobjects where name = 'stp_PostLSAEmails') begin
	drop procedure stp_PostLSAEmails
end
go

create procedure stp_PostLSAEmails
as
begin


-- get leads that signed an LSA yesterday but haven't completed ver yet
select lsa.leadapplicantid, lc.clientid, l.leadname, l.email, l.companyid, u.firstname + ' ' + u.lastname [rep]
into #emails
from vw_enrollment_LSA_complete lsa
join vw_leadapplicant_client lc on lc.leadapplicantid = lsa.leadapplicantid
	and lc.clientid not in (select distinct clientid from tblclientemails where [type] = 'Post LSA')
join tblclient c on c.clientid = lc.clientid and c.currentclientstatusid not in (17) -- Cancelled
join tblleadapplicant l on l.leadapplicantid = lsa.leadapplicantid and l.statusid not in (12) -- Declined Representation
join tbluser u on u.userid = l.repid
where lsa.completed between cast(convert(varchar(10),dateadd(d,-1,getdate()),101) as datetime) and dateadd(minute,-1,cast(convert(varchar(10),getdate(),101) as datetime))
and lsa.leadapplicantid not in 
(
	-- exclude leads that completed ver
	select leadapplicantid
	from vw_enrollment_Ver_complete 
	where completed is not null
)


select e.*, c.name [company], p.phonenumber
from #emails e
join tblcompany c on c.companyid = e.companyid
join tblcompanyphones p on p.companyid = c.companyid
	and p.phonetype = 48 -- CompliancePhone


drop table #emails


end
go 