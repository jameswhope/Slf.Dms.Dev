/****** Object:  StoredProcedure [dbo].[stp_CollectACHDeposits_S]    Script Date: 11/19/2007 15:26:58 ******/
DROP PROCEDURE [dbo].[stp_CollectACHDeposits_S]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_CollectACHDeposits_S]
	(
		@fordate datetime = null
	)

as

-- by default, if there is no process date specified, use one day greater then today
if @fordate is null
	begin
		set @fordate = dateadd(d, 1, getdate())
	end


-----------------------------------------------------------------------------------------------
-- LOGIC FOR COLLECTING MONTHLY ACH DEPOSITS
-- (1) Determine if the for date is the last day of the month.  If it is, include any day
--     after it numerically up through 31
-- (2) Create temp table and fill it with all clients that should be collected for this
--     time period.  Use the following:
--     (a) Find where clients match up in the ACH rules first.
--     (b) Find where clients match up by their default records, excluding any that were
--         found by matching up in the ACH rules.
-- (4) Analyze the day after the current process day.  if it is a no bank day, run this
--     proc again for that day
-----------------------------------------------------------------------------------------------


-- discretionary variables
declare @registerid int
declare @lastdayofmonth bit set @lastdayofmonth = 0

declare @trustcommrecid int
declare @trustdisplay varchar (50)
declare @trustiscommercial bit
declare @trustroutingnumber varchar (50)
declare @trustaccountnumber varchar (50)
declare @trusttype varchar (1)

declare @clientid int
declare @display varchar (50)
declare @routingnumber varchar (50)
declare @accountnumber varchar (50)
declare @type varchar (1)
declare @amount money
declare @nacharegisterid int

declare @nextfordate datetime
declare @numbankholidays int


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
	istrust = 1 and commrecid = 15


-- (1) determine last day in for month
if @fordate = dateadd(dd, -(day(dateadd(mm, 1, @fordate))), dateadd(mm, 1, @fordate))
	begin
		set @lastdayofmonth = 1
	end


-- (2) create temp table
create table #temp
(
	clientid int,
	display varchar (50),
	routingnumber varchar (50),
	accountnumber varchar (50),
	[type] varchar (1),
	amount money
)


-- (1) get clients that don't have active rules
insert into
	#temp
select
	c.clientid,
	ltrim(rtrim(p.firstname)) + ' ' + ltrim(rtrim(p.lastname)),
	c.bankroutingnumber,
	c.bankaccountnumber,
	c.banktype,
	c.depositamount
from
	tblclient c inner join
	tblperson p on c.primarypersonid = p.personid
where
	(c.depositmethod = 'ach' or c.depositmethod = 'ACH') and
	c.clientid not in
	(
		select
			clientid
		from
			tblruleach r
		where
			r.startdate <= cast(convert(varchar (10), @fordate, 101) as datetime) and
			(
				r.enddate is null or
				r.enddate >= cast(convert(varchar (10), @fordate, 101) as datetime)
			)
	)
	and
	(
		c.depositday = day(@fordate) or
		(
			@lastdayofmonth = 1 and
			c.depositday >= day(@fordate)
		)
	)
	and	c.depositstartdate <= cast(convert(varchar (10), @fordate, 101) as datetime)
	and not c.currentclientstatusid in (15,17,18) 
	and (c.depositmethod = 'ach' or c.depositmethod = 'ACH')
	and c.depositday is not null 
	and c.depositday > 0 
	and c.bankaccountnumber is not null 
	and c.bankroutingnumber is not null 
	and len(c.bankaccountnumber) > 0 
	and len(c.bankroutingnumber) > 0
	and not c.depositstartdate is null
	and c.companyid = 1


-- (1) get clients that are apart of an active rule
insert into
	#temp
select
	r.clientid,
	ltrim(rtrim(p.firstname)) + ' ' + ltrim(rtrim(p.lastname)),
	r.bankroutingnumber,
	r.bankaccountnumber,
	r.banktype,
	r.depositamount
from
	tblruleach r inner join
	tblclient c on r.clientid = c.clientid inner join
	tblperson p on c.primarypersonid = p.personid
where
	r.ruleachid in
	(
		select
			min(ruleachid)
		from
			tblruleach r
		where
			r.startdate <= cast(convert(varchar (10), @fordate, 101) as datetime) and
			(
				r.enddate is null or
				r.enddate >= cast(convert(varchar (10), @fordate, 101) as datetime)
			)
			and
			(
				r.depositday = day(@fordate) or
				(
					@lastdayofmonth = 1 and
					r.depositday >= day(@fordate)
				)
			)
		group by
			clientid
	)
	and	c.depositstartdate <= cast(convert(varchar (10), @fordate, 101) as datetime)
	and not c.currentclientstatusid in (15,17,18) 
	and (c.depositmethod = 'ach' or c.depositmethod = 'ACH')
	and c.depositday is not null 
	and c.depositday > 0 
	and c.bankaccountnumber is not null 
	and c.bankroutingnumber is not null 
	and len(c.bankaccountnumber) > 0 
	and len(c.bankroutingnumber) > 0
	and not c.depositstartdate is null
	and c.companyid = 1



-- (2) loop ach's
declare collect_CollectACHDeposits cursor local for select * from #temp where amount > 0

open collect_CollectACHDeposits
fetch next from collect_CollectACHDeposits into @clientid, @display, @routingnumber, @accountnumber, @type, @amount

while @@fetch_status = 0
	begin

		-- initialize each time inside the loop
		set @registerid = null

		-- find if an ach deposit was already added to this client for the current month/year
		select
			@registerid = registerid
		from
			tblregister
		where
			clientid = @clientid and
			achmonth = month(@fordate) and
			achyear = year(@fordate)

		if @registerid is null -- nothing was entered for this month
			begin

				-- insert an sda deposit transaction (where the trandate and holddate are the process day)
				insert into
					tblregister
					(
						clientid,
						transactiondate,
						amount,
						entrytypeid,
						hold,
						holdby,
						achmonth,
						achyear
					)
				values
					(
						@clientid,
						convert(datetime, convert(varchar (50), @fordate, 101)),
						abs(@amount),
						3,
						convert(datetime, convert(varchar (50), @fordate, 101)),
						24, -- import engine
						month(@fordate),
						year(@fordate)
					)

				-- return the fresh id
				set @registerid = scope_identity()


				--  *** DON'T BOTHER WITH THE BELOW - DEPOSIT ENTERED FOR FUTURE DAY ***
				-- pay all fees for this client (with new money just added)
				-- exec stp_PayFeeForClient @clientid


				-- write out debit against personal account
				insert into
					tblnacharegister
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
						1
					)


				-- get created nacha register id
				set @nacharegisterid = scope_identity()


				-- insert nacha cabinet records against this registerid
				insert into
					tblnachacabinet
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
				insert into
					tblnacharegister
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
						1
					)


				-- get created nacha register id
				set @nacharegisterid = scope_identity()


				-- insert nacha cabinet records against this registerid
				insert into
					tblnachacabinet
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

				-- rebalance register for client
				-- don't do entire cleanup for client - that will do payments and auto-assign negogiation
				exec stp_DoRegisterRebalanceClient @clientid


			end

		fetch next from collect_CollectACHDeposits into @clientid, @display, @routingnumber, @accountnumber, @type, @amount
	end
close collect_CollectACHDeposits
deallocate collect_CollectACHDeposits


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
if @numbankholidays > 0 or lower(datename(dw, @fordate)) = 'saturday' or lower(datename(dw, @fordate)) = 'sunday'
	begin

		print convert(varchar (50), @fordate, 101) + ' is a NO BANK day, gathering next'

		-- find the day after this process day
		set @nextfordate = dateadd(d, 1, @fordate)

		exec stp_CollectACHDeposits_S @nextfordate

	end
else
	begin
		print convert(varchar (50), @fordate, 101) + ' is a regular bank day'
	end
GO
