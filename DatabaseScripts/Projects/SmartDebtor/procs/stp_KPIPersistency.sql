IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_KPIPersistency')
	BEGIN
		DROP  Procedure  stp_KPIPersistency
	END
GO 

create procedure stp_KPIPersistency
as


select month(c.created) [mth], year(c.created) [yr], c.clientid, 
	case when n.clientid is null then c.currentclientstatusid else -1 end [currentclientstatusid],
	case when a.clientid is not null and l.statusid in (10,19) then 1 else 0 end [pending], -- In Process, Return to Compliance
	[Retention] = datediff(day,c.created,(select top(1) rm.created from tblroadmap rm where rm.clientstatusid = 17 and rm.clientid = c.clientid and rm.clientstatusid = c.currentclientstatusid order by roadmapid desc)) -- Inactive, Cancelled
into #clients
from tblleadapplicant l
join vw_leadapplicant_client v on v.leadapplicantid = l.leadapplicantid
join tblclient c on c.clientid = v.clientid
join tblleadproducts p on p.productid = l.productid 
left join vw_NonDepositClients n on n.clientid = c.clientid
left join tblPendingApproval a on a.clientid = c.clientid
where c.created >= '1/1/2010'


select 
	mth, yr,
	datename(month, cast(mth as varchar(2)) + '/1/1900') + ' ' + cast(yr as char(4)) [mthyr],
	count(*) [submittedcases],
	sum(case when currentclientstatusid = 14 then 1 else 0 end) [active],
	sum(case when currentclientstatusid = 14 then 1 else 0 end) / cast(count(*) as money) [activepct],
	sum(case when currentclientstatusid = 17 then 1 else 0 end) [cancelled], 
	sum(case when currentclientstatusid = 15 and pending = 0 then 1 else 0 end) [inactive], -- Inactive and not pending atty approval
	sum(case when currentclientstatusid in (7,24,23) and pending = 0 then 1 else 0 end) [pending], -- Recieved LSA, Return to Compliance, Return to CID, and not pending atty approval
	sum(case when currentclientstatusid = -1 then 1 else 0 end) [nondeposit],
	sum(case when pending = 1 then 1 else 0 end) [pendingapproval], 
	sum(case when [retention] between 0 and 30 then 1 else 0 end) [30days],
	sum(case when [retention] between 0 and 30 then 1 else 0 end) / cast(count(*) as money) [30dayspct],
	sum(case when [retention] between 31 and 60 then 1 else 0 end) [60days],
	sum(case when [retention] between 31 and 60 then 1 else 0 end) / cast(count(*) as money) [60dayspct],
	sum(case when [retention] between 61 and 90 then 1 else 0 end) [90days],
	sum(case when [retention] between 61 and 90 then 1 else 0 end) / cast(count(*) as money) [90dayspct],
	sum(case when [retention] between 91 and 180 then 1 else 0 end) [6months],
	sum(case when [retention] between 91 and 180 then 1 else 0 end) / cast(count(*) as money) [6monthspct],
	sum(case when [retention] between 181 and 270 then 1 else 0 end) [9months],
	sum(case when [retention] between 181 and 270 then 1 else 0 end) / cast(count(*) as money) [9monthspct],
	sum(case when [retention] > 271 then 1 else 0 end) [9monthsplus],
	sum(case when [retention] > 271 then 1 else 0 end) / cast(count(*) as money) [9monthspluspct]
into #months
from #clients
group by mth, yr


select *
from #months
order by yr desc, mth desc


select 
	datename(month, cast(c.mth as varchar(2)) + '/1/1900') + ' ' + cast(c.yr as char(4)) [mthyr],
	isnull(c.[retention],0) [retention],
	count(*) [cases],
	count(*) / cast(submittedcases as money) [casespct]
from #clients c
join #months m on m.mth = c.mth and m.yr = c.yr
where (c.[retention] is not null or c.clientid is null)
group by c.mth, c.yr, isnull([retention],0), submittedcases
order by c.yr desc, c.mth desc, [retention]


select 
	count(*) [submittedcases],
	sum(case when currentclientstatusid = 14 then 1 else 0 end) [active],
	sum(case when currentclientstatusid = 14 then 1 else 0 end) / cast(count(*) as money) [activepct],
	sum(case when currentclientstatusid = 17 then 1 else 0 end) [cancelled], 
	sum(case when currentclientstatusid = 15 and pending = 0 then 1 else 0 end) [inactive], -- Inactive and not pending atty approval
	sum(case when currentclientstatusid in (7,24,23) and pending = 0 then 1 else 0 end) [pending], -- Recieved LSA, Return to Compliance, Return to CID, and not pending atty approval
	sum(case when currentclientstatusid = -1 then 1 else 0 end) [nondeposit],
	sum(case when pending = 1 then 1 else 0 end) [pendingapproval], 
	sum(case when [retention] between 0 and 30 then 1 else 0 end) [30days],
	sum(case when [retention] between 0 and 30 then 1 else 0 end) / cast(count(*) as money) [30dayspct],
	sum(case when [retention] between 31 and 60 then 1 else 0 end) [60days],
	sum(case when [retention] between 31 and 60 then 1 else 0 end) / cast(count(*) as money) [60dayspct],
	sum(case when [retention] between 61 and 90 then 1 else 0 end) [90days],
	sum(case when [retention] between 61 and 90 then 1 else 0 end) / cast(count(*) as money) [90dayspct],
	sum(case when [retention] between 91 and 180 then 1 else 0 end) [6months],
	sum(case when [retention] between 91 and 180 then 1 else 0 end) / cast(count(*) as money) [6monthspct],
	sum(case when [retention] between 181 and 270 then 1 else 0 end) [9months],
	sum(case when [retention] between 181 and 270 then 1 else 0 end) / cast(count(*) as money) [9monthspct],
	sum(case when [retention] > 271 then 1 else 0 end) [9monthsplus],
	sum(case when [retention] > 271 then 1 else 0 end) / cast(count(*) as money) [9monthspluspct]
from #clients


drop table #clients
drop table #months


