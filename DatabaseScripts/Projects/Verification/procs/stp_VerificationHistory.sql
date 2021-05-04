IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_VerificationHistory')
	BEGIN
		DROP  Procedure  stp_VerificationHistory
	END
GO

create procedure stp_VerificationHistory
as
begin
-- last 30 days


select cast(convert(varchar(10),v.completed,101) as datetime) [completed],
	'' [company],
	'' [rep],
	'' [client],
	count(*) [clients],
	1 [seq]
from vw_enrollment_Ver_complete v
where v.completed is not null
and v.completed > dateadd(d,-30,cast(convert(varchar(10),getdate(),101) as datetime))
group by convert(varchar(10),v.completed,101)

union all

select cast(convert(varchar(10),v.completed,101) as datetime) [completed],
	co.shortconame [company],
	'' [rep],
	'' [client],
	count(*) [clients],
	2 [seq]
from vw_enrollment_Ver_complete v
join vw_leadapplicant_client l on l.leadapplicantid = v.leadapplicantid
join tblclient c on c.clientid = l.clientid
join tblcompany co on co.companyid = c.companyid
where v.completed is not null
and v.completed > dateadd(d,-30,cast(convert(varchar(10),getdate(),101) as datetime))
group by convert(varchar(10),v.completed,101), co.shortconame

union all

select cast(convert(varchar(10),v.completed,101) as datetime) [completed],
	co.shortconame [company],
	u.firstname + ' ' + u.lastname [rep],
	'' [client],
	count(*) [clients],
	3 [seq]
from vw_enrollment_Ver_complete v
join vw_leadapplicant_client lc on lc.leadapplicantid = v.leadapplicantid
join tblclient c on c.clientid = lc.clientid
join tblcompany co on co.companyid = c.companyid
join tblleadapplicant l on l.leadapplicantid = lc.leadapplicantid
join tbluser u on u.userid = l.repid
where v.completed is not null
and v.completed > dateadd(d,-30,cast(convert(varchar(10),getdate(),101) as datetime))
group by convert(varchar(10),v.completed,101), co.shortconame, u.firstname, u.lastname

union all

select cast(convert(varchar(10),v.completed,101) as datetime) [completed],
	co.shortconame [company],
	u.firstname + ' ' + u.lastname [rep],
	c.accountnumber + ' - ' + p.firstname + ' ' + p.lastname [client],
	1 [clients],
	4 [seq]
from vw_enrollment_Ver_complete v
join vw_leadapplicant_client lc on lc.leadapplicantid = v.leadapplicantid
join tblclient c on c.clientid = lc.clientid
join tblcompany co on co.companyid = c.companyid
join tblleadapplicant l on l.leadapplicantid = lc.leadapplicantid
join tbluser u on u.userid = l.repid
join tblperson p on p.personid = c.primarypersonid
where v.completed is not null
and v.completed > dateadd(d,-30,cast(convert(varchar(10),getdate(),101) as datetime))

order by [completed] desc, [company], [rep], client


end
go 