IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ReAssignMonthlyFeesForClient')
	BEGIN
		DROP  Procedure  stp_ReAssignMonthlyFeesForClient
	END

GO

/****** Object:  StoredProcedure [dbo].[stp_ReAssessMonthlyFeeForClient]    Script Date: 09/30/2009 10:48:14 by Jim Hope ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[stp_ReAssessMonthlyFeeForClient] 
	(
		@From datetime,
		@ToDate datetime = null,
		@ClientID int
	)

as

--select * from tblregister where entrytypeid = 1 and  clientid = 35778

----*******For Testing********
--Declare @From datetime
--Declare @ToDate datetime
--Declare @ClientID int
--
--Set @From = '05/01/2007'
--Set @ClientID = 35778 
----************************

DECLARE @TestDate datetime
DECLARE @fordate datetime
DECLARE @Bigcounter int

IF @ToDate IS NULL BEGIN
	SET @ToDate = getdate()
END
SET @Bigcounter = 0
SET @TestDate = @From 

declare @feeday int
declare @feemonth int
declare @feeyear int
declare @feemonthname varchar(50)
declare @lastdayinmonth int
declare @islastdayinmonth bit

--declare @clientid int
declare @monthlyfee money
declare @subsequentmaintfee money
declare	@submaintfeestart datetime
declare @maintenancefeecap money

WHILE @TestDate <= dateadd(month, -1, @ToDate)
BEGIN 

	SET @testdate = dateadd(month, @BigCounter, @From)
	SET @fordate = @testdate
	SET @BigCounter = @BigCounter + 1

	SET @feeday = datepart(day,@fordate)
	SET @feemonth = datepart(month,@fordate)
	SET @feeyear = datepart(year,@fordate)
	SET @feemonthname=datename(mm, @fordate)
	SET @lastdayinmonth = datepart(day, dateadd(day, -1, dateadd(month, datediff(month, 0, @fordate)+1, 0)))
	SET @islastdayinmonth = case when @feeday=@lastdayinmonth then 1 else 0 end

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
	and not clientid in (select clientid from tblregister where feemonth=@feemonth and feeyear=@feeyear AND void IS NULL and clientid = @clientid)
		--and fee has not already been assessed for this month
	and not monthlyfee is null
	and not monthlyfee = 0
	and clientid = @clientid
	
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
		and clientid = @clientid
	--If today is last day of month, take everyone with feedays for >= today

open c
fetch next from c into @clientid,@monthlyfee,@subsequentmaintfee,@submaintfeestart,@maintenancefeecap

while @@fetch_status = 0
begin

	if @maintenancefeecap is not null and @maintenancefeecap <> 0
	begin
	
		select @monthlyfee = count(a.accountid) * @monthlyfee from tblaccount a
		where a.clientid = @clientid
		and a.accountstatusid <> 55
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
		getdate(),
		-@monthlyfee,
		1, 
		'Maintenance Fee for ' + @feemonthname + ' ' + convert(varchar, @feeyear),
		@feemonth,
		@feeyear
	)

	-- rebalance register for client
	-- don't do entire cleanup for client - that will do payments and auto-assign negogiation
	exec stp_PayFeeForClient @Clientid
	exec stp_DoRegisterRebalanceClient @clientid

	fetch next from c into @clientid,@monthlyfee,@subsequentmaintfee,@submaintfeestart,@maintenancefeecap

end

close c
deallocate c

drop table #tmpClients

END



GO

/*
GRANT EXEC ON stp_ReAssignMonthlyFeesForClient TO PUBLIC

GO
*/

