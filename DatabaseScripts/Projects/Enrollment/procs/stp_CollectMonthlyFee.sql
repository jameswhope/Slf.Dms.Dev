IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CollectMonthlyFee')
	BEGIN
		DROP  Procedure  stp_CollectMonthlyFee
	END

GO

Create procedure  stp_CollectMonthlyFee 
	(
		@fordate datetime = null
	)

as

if @fordate is null begin
	set @fordate = getdate()
end

declare @feeday int
declare @feemonth int
declare @feeyear int
declare @feemonthname varchar(50)
set @feeday = datepart(day,@fordate)
set @feemonth = datepart(month,@fordate)
set @feeyear = datepart(year,@fordate)
set @feemonthname=datename(mm, @fordate)
declare @lastdayinmonth int
declare @islastdayinmonth bit
set @lastdayinmonth = datepart(day, dateadd(day, -1, dateadd(month, datediff(month, 0, @fordate)+1, 0)))
set @islastdayinmonth = case when @feeday=@lastdayinmonth then 1 else 0 end


declare @clientid int
declare @monthlyfee money
declare @subsequentmaintfee money
declare	@submaintfeestart datetime
declare @maintenancefeecap money

select 
	clientid,
	monthlyfee,
	case  
		when monthlyfeeday=0 then 1
		else isnull(monthlyfeeday, 1)
	end as monthlyfeeday,--If monthlyfeeday is 0 or null, treat as 1
	subsequentmaintfee,
	submaintfeestart,
	maintenancefeecap
into 
	#tmpClients
from 
	tblclient 
where
	currentclientstatusid not in (15,17,18) and 
	(
		@fordate >= monthlyfeestartdate or
		monthlyfeestartdate is null
	)
	and not clientid in 
		(select clientid from tblregister where feemonth=@feemonth and feeyear=@feeyear)
		--and fee has not already been assessed for this month
	and not monthlyfee is null
	and not monthlyfee = 0

declare @count int
set @count=(
	select 
		count(clientid)
	from 
		#tmpClients 
	where
		monthlyfeeday=@feeday
		or (@islastdayinmonth=1 and monthlyfeeday >= @feeday)
)

declare c cursor for 
	select 
		clientid,
		monthlyfee,
		subsequentmaintfee,
		submaintfeestart,
		maintenancefeecap
	from 
		#tmpClients 
	where
		monthlyfeeday=@feeday
		or (@islastdayinmonth=1 and monthlyfeeday >= @feeday)
	--If today is last day of month, take everyone with feedays for >= today

open c
fetch next from c into @clientid,@monthlyfee,@subsequentmaintfee,@submaintfeestart,@maintenancefeecap

while @@fetch_status = 0
begin

	if @maintenancefeecap is not null and @maintenancefeecap <> 0
	begin
	
		select @monthlyfee = count(a.accountid) * @monthlyfee from tblaccount a
		where a.clientid = @clientid
		and a.accountstatusid not in (55,171) -- Removed, NR
		and not (a.accountstatusid = 54 and exists(select r.registerid from tblregister r where r.entrytypeid = 4 and r.accountid = a.accountid and r.void is null and r.isfullypaid = 1))
		
		if @monthlyfee > @maintenancefeecap 
			select @monthlyfee = @maintenancefeecap
			
	end
	else if @subsequentmaintfee is not null and @subsequentmaintfee <> 0 and @submaintfeestart is not null and @fordate >= @submaintfeestart 
		select @monthlyfee = @subsequentmaintfee
	

	INSERT INTO tblRegister
	(
		ClientId,
		TransactionDate,
		Amount,
		EntryTypeId, 
		Description,
		FeeMonth,
		FeeYear
	)
	values
	(
		@clientid,
		@fordate,
		-@monthlyfee,
		1, 
		'Maintenance Fee for ' + @feemonthname + ' ' + convert(varchar, @feeyear),
		@feemonth,
		@feeyear
	)


	-- rebalance register for client
	-- don't do entire cleanup for client - that will do payments and auto-assign negogiation
	--exec stp_DoRegisterRebalanceClient @clientid


	fetch next from c into @clientid,@monthlyfee,@subsequentmaintfee,@submaintfeestart,@maintenancefeecap
end

close c
deallocate c



print convert(varchar,@count) + ' total maintenance fees were assessed'

drop table #tmpClients

