IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_TransferHistory')
	BEGIN
		DROP  Procedure  stp_TransferHistory
	END
GO

create procedure stp_TransferHistory
as
begin


select cast(convert(varchar(10),v.minstatuscreated,101) as datetime) [transferred], 
	'' [company],
	'' [rep],
	'' [client],
	count(*) [Clients],
	1 [seq]
from tblclient c
join tblimportedclient i on i.importid = c.serviceimportid
join tblleadapplicant l on l.leadapplicantid = i.externalclientid 
join vw_enrollment_CurrentStatusCreated v on v.leadapplicantid = l.leadapplicantid and v.currentstatusid in (10,19) -- In Process, Return to Compliance
where v.minstatuscreated > dateadd(d,-60,cast(convert(varchar(10),getdate(),101) as datetime))
group by convert(varchar(10),v.minstatuscreated,101)

union all

select cast(convert(varchar(10),v.minstatuscreated,101) as datetime) [transferred], 
	co.shortconame [company],
	'' [rep],
	'' [client],
	count(*) [clients],
	2 [seq]
from tblclient c
join tblimportedclient i on i.importid = c.serviceimportid
join tblleadapplicant l on l.leadapplicantid = i.externalclientid 
join vw_enrollment_CurrentStatusCreated v on v.leadapplicantid = l.leadapplicantid and v.currentstatusid in (10,19) -- In Process, Return to Compliance
join tblcompany co on co.companyid = c.companyid
where v.minstatuscreated > dateadd(d,-60,cast(convert(varchar(10),getdate(),101) as datetime))
group by convert(varchar(10),v.minstatuscreated,101), co.shortconame

union all

select cast(convert(varchar(10),v.minstatuscreated,101) as datetime) [transferred], 
	co.shortconame [company],
	u.firstname + ' ' + u.lastname [rep],
	'' [client],
	count(*) [clients],
	3 [seq]
from tblclient c
join tblimportedclient i on i.importid = c.serviceimportid
join tblleadapplicant l on l.leadapplicantid = i.externalclientid 
join vw_enrollment_CurrentStatusCreated v on v.leadapplicantid = l.leadapplicantid and v.currentstatusid in (10,19) -- In Process, Return to Compliance
join tblcompany co on co.companyid = c.companyid
join tbluser u on u.userid = l.repid
where v.minstatuscreated > dateadd(d,-60,cast(convert(varchar(10),getdate(),101) as datetime))
group by convert(varchar(10),v.minstatuscreated,101), co.shortconame, u.firstname, u.lastname

union all

select cast(convert(varchar(10),v.minstatuscreated,101) as datetime) [transferred], 
	co.shortconame[company],
	u.firstname + ' ' + u.lastname [rep],
	c.accountnumber + ' - ' + p.firstname + ' ' + p.lastname [client],
	1 [clients],
	4 [seq]
from tblclient c
join tblimportedclient i on i.importid = c.serviceimportid
join tblleadapplicant l on l.leadapplicantid = i.externalclientid 
join vw_enrollment_CurrentStatusCreated v on v.leadapplicantid = l.leadapplicantid and v.currentstatusid in (10,19) -- In Process, Return to Compliance
join tblperson p on p.personid = c.primarypersonid
join tblcompany co on co.companyid = c.companyid
join tbluser u on u.userid = l.repid
where v.minstatuscreated > dateadd(d,-60,cast(convert(varchar(10),getdate(),101) as datetime))

order by [transferred] desc, [company], [rep], client


end
go 