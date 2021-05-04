IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDepositRetention')
	DROP  Procedure  stp_NonDepositRetention
GO

create procedure stp_NonDepositRetention
(
	@repid int
)
as
begin

-- CID non-deposits by month
select month(nondepositdate) [month], year(nondepositdate) [year], count(*) [nondeposits]
into #nondep
from (
	select n.clientid, case when nondeposittypeid = 2 then r.transactiondate else n.misseddate end [nondepositdate]
	from tblnondeposit n
	join vw_leadapplicant_client v on v.clientid = n.clientid
	join tblleadapplicant l on l.leadapplicantid = v.leadapplicantid
		and l.repid = @repid
	left join tblregister r on r.registerid = n.depositid
	where n.deleted is null
	and (year(n.misseddate) > 2010 or year(r.transactiondate) > 2010)
) d
group by month(nondepositdate), year(nondepositdate)


-- Currently good CID non-deposit replacements (could bounce later)
select 
	datename(month,cast(n.[month] as varchar(2))+'/1/2000') + ' ' + cast(n.[year] as char(4)) [monthyear], 
	n.*, 
	isnull(r.replacements,0) [replacements], 
	cast(case when n.nondeposits > 0 then r.replacements / cast(n.nondeposits as money) else 0.0 end as decimal(4,3)) [conv],
	c.adjustment
from #nondep n
left join (
	select month(r.transactiondate) [month], year(r.transactiondate) [year], count(*) [replacements]
	from tblnondeposit n
	join vw_leadapplicant_client v on v.clientid = n.clientid
	join tblleadapplicant l on l.leadapplicantid = v.leadapplicantid
		and l.repid = @repid
	join tblnondepositreplacementregisterxref x on x.replacementid = n.currentreplacementid
	join tblregister r on r.registerid = x.registerid
		and r.bounce is null
		and (r.hold is null or r.clear < getdate())
		and r.transactiondate < getdate()
	left join tblregister d on d.registerid = n.depositid
	where n.deleted is null
	and (year(n.misseddate) > 2010 or year(d.transactiondate) > 2010)
	group by month(r.transactiondate), year(r.transactiondate)
) r
on r.[month] = n.[month] and r.[year] = n.[year]
join tblIncentiveNonDepositChart c on cast(case when n.nondeposits > 0 then r.replacements / cast(n.nondeposits as money) else 0.0 end as decimal(4,3)) between convmin and convmax
order by n.[year], n.[month]


end
go 