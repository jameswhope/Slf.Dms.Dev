-- stp_RunningBalance '1/29/09', '2/4/09' used for agency/potential/outlook.aspx
-- stp_RunningBalance2 used for agency/runningbalance.aspz

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_RunningBalance2')
	BEGIN
		DROP  Procedure  stp_RunningBalance2
	END

GO

create procedure stp_RunningBalance2
(
	@startdate datetime,
	@enddate datetime,
	@userid int
)
as
begin

declare 
	@date datetime, 
	@payments money, 
	@chargebacks money,
	@dailynet money, 
	@runningbal money,
	@checkbal bit,
	@commstructid int,
	@curcommstructid int

declare @vtblCal table (TransactionDate datetime)


create table #comms
(
	commstructid int,
	[date] varchar(20),
	payments money,
	chargebacks money,
	entrytypeid int
)

create table #temp2
(
	commstructid int,
	[date] datetime,
	payments money,
	chargebacks money,
	dailynet money default(0),
	runningbal money default(0)
)

create table #results
(
	commstructid int,
	[date] datetime,
	payments money,
	chargebacks money,
	dailynet money,
	calcdnet money,
	runningbal money,
	batched money
)

create table #startdates
(
	commstructid int,
	startdate datetime
)


-- fill calendar
with mycte as
(
	select @startdate [DateValue]
	union all
	select DateValue + 1
	from mycte    
	where DateValue + 1 <= @enddate
)

insert @vtblCal
select DateValue
from mycte
where datevalue between @startdate and @enddate order by datevalue desc
OPTION  (MAXRECURSION 0)


set @enddate = dateadd(day,1,@enddate)


-- startdate has to be a day that a batch went out which means the prev business day has a $0 running bal
insert #startdates (commstructid, startdate)
select cp.commstructid, cast(convert(char(10),max(b.batchdate),10) as datetime)
from tblcommpay cp
join tblcommbatch b on b.commbatchid = cp.commbatchid
join tblcommstruct cs on cs.commstructid = cp.commstructid
join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @userid
join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid 
where b.batchdate < dateadd(day,1,@startdate)
group by cp.commstructid


-- for new companys that may not have older batches
insert #startdates (commstructid, startdate)
select commstructid, startdate
from (
	select cs.commstructid, dateadd(day,-4,cast(convert(char(10),min(b.batchdate),10) as datetime)) [startdate] -- go 4 days back to account for weekends and holidays
	from tblcommbatchtransfer cbt
	join tblcommbatch b on b.commbatchid = cbt.commbatchid
	join tblcommscen s on s.commscenid = b.commscenid
	join tblcommstruct cs on cs.commscenid = s.commscenid and cs.commrecid = cbt.commrecid and cs.parentcommrecid = cbt.parentcommrecid and cs.companyid = cbt.companyid
	join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @userid	
	join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and uca.companyid = cbt.companyid
	where b.batchdate between @startdate and @enddate and cbt.companyid > 0
	group by cs.commstructid
) d 
where not exists (select 1 from #startdates s where s.commstructid = d.commstructid)
--select * from #startdates order by commstructid


-- payment acivity by paymentdate
insert
	#comms (commstructid, entrytypeid, date, payments)
select 
	d.commstructid, entrytypeid, convert(varchar(10),paymentdate,101) [date], sum(amount) [payments]
from (
	SELECT
		cs.commstructid,
		r.entrytypeid,
		case when datediff(day,rp.paymentdate,b.batchdate) = 2 then dateadd(dd,1,rp.paymentdate) else rp.paymentdate end [paymentdate],
		cp.amount	
	FROM
		tblCommPay as cp
		join tblRegisterPayment as rp on rp.RegisterPaymentID = cp.RegisterPaymentID 
		join tblRegister as r on r.RegisterID = rp.FeeRegisterID
		join tblClient as c on c.ClientID = r.ClientID
		join tblCommStruct as cs on cs.CommStructID = cp.CommStructID 
		join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @userid	
		join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid 
		join #startdates t on t.commstructid = cs.commstructid
		left join tblcommbatch b on b.commbatchid = cp.commbatchid
	WHERE
		rp.paymentdate between t.startdate and @enddate
) d
join #startdates t on t.commstructid = d.commstructid and paymentdate between t.startdate and @enddate -- needed to filter out dateadds that fall out of the date range
group by
	d.commstructid, entrytypeid, convert(varchar(10),paymentdate,101)


-- chargeback activity by day
insert
	#comms (commstructid, entrytypeid, [date], chargebacks)
select 
	d.commstructid, entrytypeid, convert(varchar(10),chargebackdate,101) [date], sum(amount) [chargebacks]
from (
	-- by chargeback date
	SELECT
		cs.commstructid, 
		r.entrytypeid,
		case when datediff(day,cc.chargebackdate,b.batchdate) = 0 then dateadd(dd,-1,cc.chargebackdate) else cc.chargebackdate end [chargebackdate], -- checksite chargebacks batched the same day need to be placed in the previous day's activity
		-cc.amount [amount]
	FROM
		tblCommChargeback as cc
		join tblRegisterPayment as rp on rp.RegisterPaymentID = cc.RegisterPaymentID
		join tblRegister as r on r.RegisterID = rp.FeeRegisterID
		join tblClient as c on c.ClientID = r.ClientID 
		join tblCommStruct as cs on cs.CommStructID = cc.CommStructID 
		join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @userid	
		join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid 
		join #startdates t on t.commstructid = cs.commstructid
		left join tblcommbatch b on b.commbatchid = cc.commbatchid
	WHERE
		cc.chargebackdate between t.startdate and @enddate
) d
join #startdates t on t.commstructid = d.commstructid and chargebackdate between t.startdate and @enddate -- needed to filter out dateadds that fall out of the date range
group by
	d.commstructid, entrytypeid, convert(varchar(10),chargebackdate,101)




insert #temp2 (commstructid, [date], payments, chargebacks)
select commstructid, cast([date] as datetime), isnull(sum(payments),0), isnull(sum(chargebacks),0)
from #comms
group by commstructid, [date]


set @curcommstructid = -1
--select commstructid, [date], payments, chargebacks from #temp2 where commstructid = 839 order by commstructid, [date]

declare cur cursor for 
	select commstructid, [date], payments, chargebacks from #temp2 order by commstructid, [date]

open cur
fetch next from cur into @commstructid, @date, @payments, @chargebacks
while @@fetch_status = 0 begin

	if @commstructid <> @curcommstructid begin
		set @runningbal = 0
		set @curcommstructid = @commstructid
	end	
	
	if @checkbal = 1 begin
		-- positive running bal, but if this is a weekend, carryover the running bal
		if not (datename(dw,@date) = 'Saturday' or datename(dw,@date) = 'Sunday') and not exists (select 1 from tblbankholiday where date = @date) begin
			set @runningbal = 0
		end
		set @checkbal = 0 -- reset
	end

	set @dailynet = @payments + @chargebacks + @runningbal

	if @dailynet > 0 begin
		-- pay them
		update #temp2 
		set dailynet = @dailynet, runningbal = @dailynet
		where date = @date 
		and commstructid = @commstructid

		set @checkbal = 1
	end
	else begin
		-- they have a running balance
		update #temp2 
		set dailynet = 0, runningbal = @dailynet
		where date = @date 
		and commstructid = @commstructid
	end
	
	set @runningbal = @dailynet

	fetch next from cur into @commstructid, @date, @payments, @chargebacks
end

close cur
deallocate cur


insert #results (commstructid, date, payments, chargebacks, dailynet, calcdnet, runningbal, batched)
select t.commstructid, v.transactiondate, isnull(t.Payments,0), isnull(t.Chargebacks,0), (isnull(t.Payments,0) + isnull(t.Chargebacks,0)), isnull(t.dailynet,0), isnull(t.RunningBal,0), isnull(b.amount,0)
from @vtblCal v
left join #temp2 t on t.date = v.transactiondate
left join 
(
	select cs.commstructid, convert(varchar(10),b.batchdate,101) [date], sum(cbt.transferamount) [amount]
	from tblcommbatchtransfer cbt
	join tblcommbatch b on b.commbatchid = cbt.commbatchid
	join tblcommscen s on s.commscenid = b.commscenid
	join tblcommstruct cs on cs.commscenid = s.commscenid and cs.commrecid = cbt.commrecid and cs.parentcommrecid = cbt.parentcommrecid and cs.companyid = cbt.companyid
	join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @userid	
	join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and uca.companyid = cbt.companyid
	where b.batchdate between @startdate and @enddate
	group by cs.commstructid, convert(varchar(10),b.batchdate,101)

) b on b.date = t.date and b.commstructid = t.commstructid
where t.commstructid > 0


-- pickup any dates where a batch was sent but there was no payment/chargeback activity
insert #results (commstructid, date, payments, chargebacks, dailynet, calcdnet, runningbal, batched)
select commstructid, date, payments, chargebacks, dailynet, calcdnet, runningbal, batched
from (
	select cs.commstructid, convert(varchar(10),b.batchdate,101) [date], 0 [payments], 0 [chargebacks], 0 [dailynet], 0 [calcdnet], 0 [runningbal], sum(cbt.transferamount) [batched]
	from tblcommbatchtransfer cbt
	join tblcommbatch b on b.commbatchid = cbt.commbatchid
	join tblcommscen s on s.commscenid = b.commscenid
	join tblcommstruct cs on cs.commscenid = s.commscenid and cs.commrecid = cbt.commrecid and cs.parentcommrecid = cbt.parentcommrecid and cs.companyid = cbt.companyid
	join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @userid	
	join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and uca.companyid = cbt.companyid
	where b.batchdate between @startdate and @enddate
	group by cs.commstructid, convert(varchar(10),b.batchdate,101)
) b 
where not exists (
	select 1 from #results r where r.commstructid = b.commstructid and r.date = b.date)


-- ------------------------- OUTPUT -------------------------

select distinct date
from #results
order by date

select distinct cr.abbreviation + ' (' + cast(cr.commrecid as varchar(3)) + ') ' + a.importabbr + ' (' + cast(cs.commstructid as varchar(5)) + ')' [commrec]
from #results r
join tblcommstruct cs on cs.commstructid = r.commstructid
join tblcommrec cr on cr.commrecid = cs.commrecid
join tblcommscen s on s.commscenid = cs.commscenid
join tblagency a on a.agencyid = s.agencyid
order by commrec

select distinct c.name[company]
from #results r
join tblcommstruct cs on cs.commstructid = r.commstructid
join tblcompany c on c.companyid = cs.companyid
order by company

select cr.abbreviation + ' (' + cast(cr.commrecid as varchar(3)) + ') ' + a.importabbr + ' (' + cast(cs.commstructid as varchar(5)) + ')' [commrec], c.name[company], date, Payments, Chargebacks, dailynet [Daily Net], runningbal [Running Balance], Batched--, calcdnet [Calculated Net]
from #results r
join tblcommstruct cs on cs.commstructid = r.commstructid
join tblcommrec cr on cr.commrecid = cs.commrecid
join tblcompany c on c.companyid = cs.companyid
join tblcommscen s on s.commscenid = cs.commscenid
join tblagency a on a.agencyid = s.agencyid
order by commrec, company, date


-- payment detail
select
	cr.abbreviation + ' (' + cast(cr.commrecid as varchar(3)) + ') ' + a.importabbr + ' (' + cast(c.commstructid as varchar(5)) + ')' [commrec],
	comp.name [company],
	e.displayname [feetype],
	date,
	payments [amount]
from #comms c
join tblcommstruct cs on cs.commstructid = c.commstructid
join tblcompany comp on comp.companyid = cs.companyid
join tblentrytype e on e.entrytypeid = c.entrytypeid
join tblcommrec cr on cr.commrecid = cs.commrecid
join tblcommscen s on s.commscenid = cs.commscenid
join tblagency a on a.agencyid = s.agencyid
where c.payments is not null
order by commrec, company, feetype, date



-- chargeback detail
select 
	commrec,
	company,
	[date],
	detail,
	-amount[amount]
into
	#chargebackdetail
from (
	select 
		cr.abbreviation + ' (' + cast(cr.commrecid as varchar(3)) + ') ' + a.importabbr + ' (' + cast(d.commstructid as varchar(5)) + ')' [commrec],
		comp.name [company], 
		convert(varchar(10),chargebackdate,101) [date], 
		'BOUNCE - ' + isnull(br.bounceddescription,isnull(d.description,'Other')) [detail],
		-sum(amount) [amount]
	from (
		-- by chargeback date
		SELECT
			cs.commstructid, 
			r.entrytypeid,
			case when datediff(day,cc.chargebackdate,b.batchdate) = 0 then dateadd(dd,-1,cc.chargebackdate) else cc.chargebackdate end [chargebackdate], -- checksite chargebacks batched the same day need to be placed in the previous day's activity
			-cc.amount [amount],
			r.bouncedreason,
			r.description,
			cs.companyid
		FROM
			tblCommChargeback as cc
			join tblRegisterPayment as rp on rp.RegisterPaymentID = cc.RegisterPaymentID
			join tblregisterpaymentdeposit rpd on rpd.registerpaymentid = rp.registerpaymentid
			join tblRegister r on r.RegisterID = rpd.depositregisterid and r.bounce is not null
			join tblCommStruct as cs on cs.CommStructID = cc.CommStructID 
			join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @userid	
			join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid 
			join #startdates t on t.commstructid = cs.commstructid
			left join tblcommbatch b on b.commbatchid = cc.commbatchid
		WHERE
			cc.chargebackdate between t.startdate and @enddate
	) d
	join #startdates t on t.commstructid = d.commstructid and chargebackdate between t.startdate and @enddate -- needed to filter out dateadds that fall out of the date range
	join tblcompany comp on comp.companyid = d.companyid
	join tblcommstruct cs on cs.commstructid = d.commstructid
	join tblcommrec cr on cr.commrecid = cs.commrecid
	join tblcommscen s on s.commscenid = cs.commscenid
	join tblagency a on a.agencyid = s.agencyid
	left join tblbouncedreasons br on br.bouncedid = d.bouncedreason
	group by
		cr.abbreviation, cr.commrecid, a.importabbr, d.commstructid, comp.name, convert(varchar(10),d.chargebackdate,101), br.bounceddescription, d.description

	union all

	select 
		cr.abbreviation + ' (' + cast(cr.commrecid as varchar(3)) + ') ' + a.importabbr + ' (' + cast(d.commstructid as varchar(5)) + ')' [commrec],
		comp.name [company], 
		convert(varchar(10),chargebackdate,101) [date], 
		'VOID - ' + clientstatus [detail],
		-sum(amount) [amount]
	from (
		-- by chargeback date
		SELECT
			cs.commstructid, 
			r.entrytypeid,
			case when datediff(day,cc.chargebackdate,b.batchdate) = 0 then dateadd(dd,-1,cc.chargebackdate) else cc.chargebackdate end [chargebackdate], -- checksite chargebacks batched the same day need to be placed in the previous day's activity
			-cc.amount [amount],
			s.name [clientstatus],
			cs.companyid
		FROM
			tblCommChargeback as cc
			join tblRegisterPayment as rp on rp.RegisterPaymentID = cc.RegisterPaymentID and rp.voided = 1 and rp.bounced = 0
			join tblRegister as r on r.RegisterID = rp.feeregisterid
			join tblClient as c on c.ClientID = r.ClientID 
			join tblclientstatus s on s.clientstatusid = c.currentclientstatusid
			join tblCommStruct as cs on cs.CommStructID = cc.CommStructID 
			join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @userid	
			join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid 
			join #startdates t on t.commstructid = cs.commstructid
			left join tblcommbatch b on b.commbatchid = cc.commbatchid
		WHERE
			cc.chargebackdate between t.startdate and @enddate
	) d
	join #startdates t on t.commstructid = d.commstructid and chargebackdate between t.startdate and @enddate -- needed to filter out dateadds that fall out of the date range
	join tblcompany comp on comp.companyid = d.companyid
	join tblcommstruct cs on cs.commstructid = d.commstructid
	join tblcommrec cr on cr.commrecid = cs.commrecid
	join tblcommscen s on s.commscenid = cs.commscenid
	join tblagency a on a.agencyid = s.agencyid
	group by
		cr.abbreviation, cr.commrecid, a.importabbr, d.commstructid, comp.name, convert(varchar(10),d.chargebackdate,101), clientstatus

) d

select *
from #chargebackdetail
order by commrec, company, detail, [date]


select distinct e.displayname [feetype]
from #comms c
join tblentrytype e on e.entrytypeid = c.entrytypeid
order by feetype


select distinct detail
from #chargebackdetail
order by detail


drop table #comms
drop table #temp2
drop table #startdates
drop table #results
drop table #chargebackdetail

end 
go