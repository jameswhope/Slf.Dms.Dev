/****** Object:  StoredProcedure [dbo].[stp_CollectMonthlyFee]    Script Date: 11/19/2007 15:26:58 ******/
DROP PROCEDURE [dbo].[stp_CollectMonthlyFee]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_CollectMonthlyFee]
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

select 
	clientid,
	monthlyfee,
	case  
		when monthlyfeeday=0 then 1
		else isnull(monthlyfeeday, 1)
	end as monthlyfeeday--If monthlyfeeday is 0 or null, treat as 1
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
		monthlyfee 
	from 
		#tmpClients 
	where
		monthlyfeeday=@feeday
		or (@islastdayinmonth=1 and monthlyfeeday >= @feeday)
	--If today is last day of month, take everyone with feedays for >= today

open c
fetch next from c into @clientid,@monthlyfee

while @@fetch_status = 0
begin
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


	fetch next from c into @clientid,@monthlyfee
end

close c
deallocate c



print convert(varchar,@count) + ' total maintenance fees were assessed'

drop table #tmpClients
GO
