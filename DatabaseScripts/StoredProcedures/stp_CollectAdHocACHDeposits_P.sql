/****** Object:  StoredProcedure [dbo].[stp_CollectAdHocACHDeposits_P]    Script Date: 11/19/2007 15:26:58 ******/
DROP PROCEDURE [dbo].[stp_CollectAdHocACHDeposits_P]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_CollectAdHocACHDeposits_P]
	(
		@fordate datetime = null
	)

as

-- by default, if there is no process date specified, use one day greater then today
if @fordate is null begin
	set @fordate = dateadd(d, 1, getdate())
end


-----------------------------------------------------------------------------------------------
-- LOGIC FOR COLLECTING MONTHLY ACH DEPOSITS
-- (1)	Create temp table and fill it with all clients that have AdHoc ACH's which should be 
--		collected for the selected day.
-- (2)	Run the process against those AdHoc ACH's.
-- (3)	Analyze the day after the current process day.  if it is a no bank day, run this
--		proc again for that day
-----------------------------------------------------------------------------------------------


-- discretionary variables
declare @registerid int

declare @trustcommrecid int
declare @trustdisplay varchar (50)
declare @trustiscommercial bit
declare @trustroutingnumber varchar (50)
declare @trustaccountnumber varchar (50)
declare @trusttype varchar (1)

declare @adhocachid int
declare @clientid int
declare @display varchar (50)
declare @routingnumber varchar (50)
declare @accountnumber varchar (50)
declare @type varchar (1)
declare @amount money
declare @nacharegisterid int

declare @nextfordate datetime
declare @numbankholidays int

declare @InitialDraftYN bit

-- get trust account info
select
	@trustcommrecid = commrecid,
	@trustdisplay = display,
	@trustiscommercial = iscommercial,
	@trustroutingnumber = routingnumber,
	@trustaccountnumber = accountnumber,
	@trusttype = [type]
from
	tblcommrec
where
	istrust = 1 and commrecid = 22


-- (2) create temp table
create table #temp
(
	adhocachid int,
	clientid int,
	display varchar (50),
	routingnumber varchar (50),
	accountnumber varchar (50),
	[type] varchar (1),
	amount money,
	InitialDraftYN int
)

-- (1) get clients that have Ad-Hoc ACH's on this day
insert into
	#temp
select
	r.adhocachid,
	r.clientid,
	ltrim(rtrim(p.firstname)) + ' ' + ltrim(rtrim(p.lastname)),
	r.bankroutingnumber,
	r.bankaccountnumber,
	r.banktype,
	r.depositamount,
	r.InitialDraftYN
from
	tbladhocach r inner join
	tblclient c on r.clientid = c.clientid inner join
	tblperson p on c.primarypersonid = p.personid
where
	not c.currentclientstatusid in (15,17,18) and
	cast(convert(varchar (10), @fordate, 101) as datetime) = cast(convert(varchar (10), r.depositdate, 101) as datetime) and
	r.registerid is null
	and c.companyid = 2

-- (2) loop ach's
declare cursor_CollectAdHocACHDeposits cursor local for select * from #temp where amount > 0

open cursor_CollectAdHocACHDeposits
fetch next from cursor_CollectAdHocACHDeposits into 
	@adhocachid, @clientid, @display, @routingnumber, @accountnumber, @type, @amount, @InitialDraftYN

while @@fetch_status = 0 begin

	-- insert an sda deposit transaction (where the trandate and holddate are the process day)
	insert into tblregister
	(
		clientid,
		transactiondate,
		amount,
		entrytypeid,
		hold,
		holdby,
		InitialDraftYN
	)
	values
	(
		@clientid,
		convert(datetime, convert(varchar (50), @fordate, 101)),
		abs(@amount),
		3,
		convert(datetime, convert(varchar (50), @fordate, 101)),
		24,
		@InitialDraftYN
	)

	-- return the fresh id
	set @registerid = scope_identity()

	-- write out debit against personal account
	insert into tblnacharegister
	(
		[name],
		accountnumber,
		routingnumber,
		[type],
		amount,
		ispersonal,
		commrecid,
		companyid
	)
	values
	(
		@display + ' (' + convert(varchar (50), @clientid) + ')',
		@accountnumber,
		@routingnumber,
		isnull(@type, 'C'),
		(abs(@amount) * -1),
		1,
		@trustcommrecid,
		2
	)

	-- get created nacha register id
	set @nacharegisterid = scope_identity()

	-- insert nacha cabinet records against this registerid
	insert into tblnachacabinet
	(
		nacharegisterid,
		[type],
		typeid
	)
	values
	(
		@nacharegisterid,
		'RegisterID',
		@registerid
	)

	-- write out credit for trust account
	insert into tblnacharegister
	(
		[name],
		accountnumber,
		routingnumber,
		[type],
		amount,
		ispersonal,
		commrecid,
		companyid
	)
	values
	(
		@trustdisplay,
		@trustaccountnumber,
		@trustroutingnumber,
		isnull(@trusttype, 'C'),
		abs(@amount),
		~@trustiscommercial,
		@trustcommrecid,
		2
	)

	-- get created nacha register id
	set @nacharegisterid = scope_identity()

	-- insert nacha cabinet records against this registerid
	insert into tblnachacabinet
	(
		nacharegisterid,
		[type],
		typeid
	)
	values
	(
		@nacharegisterid,
		'RegisterID',
		@registerid
	)

	-- update AdHoc ACH with new RegisterID
	update 
		tbladhocach 
	set
		registerid=@registerid
	where
		adhocachid=@adhocachid


	-- rebalance register for client
	-- don't do entire cleanup for client - that will do payments and auto-assign negogiation
	exec stp_DoRegisterRebalanceClient @clientid


	fetch next from cursor_CollectAdHocACHDeposits into 
		@adhocachid, @clientid, @display, @routingnumber, @accountnumber, @type, @amount, @InitialDraftYN
end

close cursor_CollectAdHocACHDeposits
deallocate cursor_CollectAdHocACHDeposits


-- cleanup
drop table #temp

-- find number of bank holidays that match this one
select
	@numbankholidays = count(bankholidayid)
from
	tblbankholiday
where
	convert(datetime, (convert(varchar (50), [date], 101))) = convert(datetime, (convert(varchar (50), @fordate, 101)))


-- if is weekend day or there are matches in the bankholiday table
if @numbankholidays > 0 or lower(datename(dw, @fordate)) = 'saturday' or lower(datename(dw, @fordate)) = 'sunday' begin

	print convert(varchar (50), @fordate, 101) + ' is a NO BANK day, gathering next'

	-- find the day after this process day
	set @nextfordate = dateadd(d, 1, @fordate)

	exec stp_CollectAdHocACHDeposits_P @nextfordate

end else begin
	print convert(varchar (50), @fordate, 101) + ' is a regular bank day'
end
GO
