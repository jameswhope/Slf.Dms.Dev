/*
stp_UnapprovedIncentives 1387,3,2010,820,0,0,0,null

declare @c int
exec stp_UnapprovedIncentives 1387,3,2010,820,0,1,0,@c output
select @c
*/

alter procedure stp_UnapprovedIncentives
(
	@repid int,
	@month int,
	@year int,
	@userid int,
	@approve bit = 0,
	@summaryonly bit = 0,
	@initcountonly bit = 0,
	@initialcount int output
)
as

declare @team table (repid int, initialcount int)
declare	@dmonth varchar(30), @themonth datetime, @from datetime, @to datetime

set @dmonth = datename(month,cast(@month as varchar(2))+'/1/2000')
set @themonth = cast(cast(@month as varchar(2)) + '/1/' + cast(@year as varchar(4)) as datetime)
set @from = dateadd(m,-1,@themonth) -- first day of last month
set @to = dateadd(minute,-1,dateadd(m,1,@themonth)) -- last day of the month


-- Initials based on first good deposit is recieved
select l.repid, lc.leadapplicantid, lc.clientid
into #initials
from vw_leadapplicant_client lc 
join tblleadapplicant l on l.leadapplicantid = lc.leadapplicantid 
	and l.repid = @repid
join vw_CIDFirstDeposits f on f.clientid = lc.clientid -- initial draft check
	and f.firstdeposit between @from and @to
where lc.clientid not in (select distinct clientid from tblincentivedetail)
order by l.repid

-- get chart
declare @reps table (repid int, clients int, initialpymt money default(0), residual money default(0), residualold money default(0))

-- if this rep is a supervisor, they won't have an individual chart
if exists (select 1 from tblsupteam where supid = @repid) begin
	if exists (select 1 from #initials) begin
		insert @reps (repid,clients,initialpymt,residual,residualold)
		select repid, count(*), 0.00, 0.00, 0.00
		from #initials
		group by repid
	end
	else begin
		-- rep doesnt have any initials
		insert @reps (repid,clients,initialpymt,residual,residualold)
		values (@repid,0,0.00,0.00,0.00)
	end
end
else begin
	insert @reps (repid,clients,initialpymt,residual,residualold)
	select c.repid, c.clients, i.initialpymt, i.residual, i.residualold
	from (
		select repid, count(*) [clients]
		from #initials
		group by repid
	) c
	join tblincentivechart i on c.clients between i.clientsmin and i.clientsmax 
	join tblincentivecharts s on s.incentivechartid = i.incentivechartid 
		and s.validto is null -- current
		and s.supervisor = 0 -- individual
	join tblIncentiveChartXref x on x.incentivechartid = s.incentivechartid
		and x.repid = c.repid
end


-- insert initial incentives
select repid, 
	clients[initialcount], initialpymt[initialpayment], clients * initialpymt[initialtotal],
	0[residualcount], residual[residualpayment], $0.00[residualtotal], residualold,
	0[teamcount], $0.00[teampayment], $0.00[teamtotal]
into #incentives
from @reps


-- get available residual clients
select i.repid, d.clientid, 1 [old]
into #rclients
from tblincentivedetail d
join tblincentives i on i.incentiveid = d.incentiveid
and i.repid = @repid
and i.incentiveyear < 2011
group by i.repid, d.clientid
having count(d.clientid) < 13 -- max residuals allowed +1 for initial

insert #rclients (i.repid,clientid,old)
select i.repid, d.clientid, 0
from tblincentivedetail d
join tblincentives i on i.incentiveid = d.incentiveid
and i.repid = @repid
and i.incentiveyear > 2010
group by i.repid, d.clientid
having count(d.clientid) < 6 -- max residuals allowed +1 for initial


-- residuals are clients that made a deposit this month
select distinct c.repid, c.clientid, c.old
into #residuals
from tblregister r 
join #rclients c on c.clientid = r.clientid
where r.entrytypeid = 3 -- Deposit
	and r.bounce is null
	and r.void is null
	and month(r.transactiondate) = @month
	and year(r.transactiondate) = @year


update #incentives
set residualcount = d.residualcount, residualtotal = d.residualtotal
from #incentives i
join (
	select i.repid, count(*) [residualcount], 
			(sum(case when r.old = 0 then 1 else 0 end) * i.residualpayment) 
		+	(sum(case when r.old = 1 then 1 else 0 end) * i.residualold) [residualtotal]
	from #incentives i
	join #residuals r on r.repid = i.repid
	group by i.repid, i.residualpayment, i.residualold
) d
on d.repid = i.repid


-- if this rep is a supervisor, get their team totals
if exists (select 1 from tblsupteam where supid = @repid) begin

	-- add team members and their eligible counts if they've already been approved
	insert @team
	select t.repid, i.initialcount
	from tblsupteam t
	left join tblincentives i on i.repid = t.repid
		and i.incentivemonth = @month
		and i.incentiveyear = @year
	where t.supid = @repid
	
	-- add supervisor to team
	insert @team 
	select @repid, initialcount
	from #incentives

	-- these reps dont have their incentives for this month approved yet
	declare cur cursor for select repid from @team where initialcount is null
	declare @rep int, @initcount int

	open cur
	fetch next from cur into @rep
	while @@fetch_status = 0 begin
		set @initcount = 0 -- reset
		
		exec stp_UnapprovedIncentives @rep, @month, @year, -1, 0, 0, 1, @initcount output

		update @team 
		set initialcount = @initcount
		where repid = @rep
		
		fetch next from cur into @rep
	end
	close cur
	deallocate cur

	update #incentives
	set teamcount = t.teamcount, teampayment = c.initialpymt, teamtotal = t.teamcount * c.initialpymt
	from #incentives i
	join (
		select sum(initialcount) [teamcount]
		from @team
	) t on 1=1
	join tblincentivechart c on t.teamcount between c.clientsmin and c.clientsmax 
	join tblincentivecharts s on s.incentivechartid = c.incentivechartid 
	and s.validto is null -- current
	and s.supervisor = 1
end


-- non-deposit retention
declare @ret table (monthyear varchar(20),[month] int,[year] int,nondeposits int,replacements int,conv decimal(4,3),adjustment money)
declare @conv decimal(4,3)
declare @adj money

insert @ret
exec stp_NonDepositRetention 1421

select @adj=adjustment  
from @ret
where [month] = @month
and [year] = @year


if (@approve = 1) begin
	declare @id int

	insert tblincentives (incentivemonth,incentiveyear,repid,initialcount,initialpayment,initialtotal,residualcount,residualpayment,residualtotal,teamcount,teampayment,teamtotal,createdby,adjustment)
	select @month,@year,repid,initialcount,initialpayment,initialtotal,residualcount,residualpayment,residualtotal,teamcount,teampayment,teamtotal,@userid,@adj
	from #incentives
	where repid = @repid
	
	select @id = scope_identity()
	
	insert tblincentivedetail (incentiveid,clientid,initial)
	select @id, clientid, 1
	from #initials
	union all
	select @id, clientid, 0
	from #residuals

	-- log team incentive (if rep belongs to a team)
	insert tblincentivesteam
	select supid, @id
	from tblsupteam t
	where t.repid = @repid
end
else begin
	if @initcountonly = 1 begin
		select @initialcount = initialcount
		from #incentives
	end
	else if @summaryonly = 1 begin
		select @dmonth + ' ' + cast(@year as char(4)) [monthyear], 
			cast(i.initialcount as varchar(10)) [initialcount], i.initialpayment, i.initialtotal, 
			i.residualcount, i.residualpayment, i.residualtotal,
			i.teamcount, i.teampayment, i.teamtotal,
			i.initialcount + i.residualcount[totalcount], i.initialtotal + i.residualtotal[totalamt], (i.initialtotal + i.residualtotal + i.teamtotal) * @adj [indteamtotal],
			@month [month], @year [year], 0[approved], @adj [adjustment]
		from #incentives i
	end
	else begin -- detail

		-- initials
		select d.clientid, c.accountnumber, v.leadapplicantid, p.firstname + ' ' + p.lastname[client], c.currentclientstatusid--, dbo.udf_NextDepositDate(d.clientid) [nextdepositdate]
		from #initials d
		join tblclient c on c.clientid = d.clientid
		join tblperson p on p.personid = c.primarypersonid
		join vw_leadapplicant_client v on v.clientid = d.clientid
		order by client

		-- residuals
		select d.clientid, c.accountnumber, v.leadapplicantid, p.firstname + ' ' + p.lastname[client], c.currentclientstatusid
		from #residuals d
		join tblclient c on c.clientid = d.clientid
		join tblperson p on p.personid = c.primarypersonid
		join vw_leadapplicant_client v on v.clientid = d.clientid
		order by client

		-- team
		select u.firstname + ' ' + u.lastname [rep], t.initialcount, 1 [seq]
		from @team t
		join tbluser u on u.userid = t.repid
		order by rep
	end
end


drop table #initials
drop table #incentives
drop table #rclients
drop table #residuals 