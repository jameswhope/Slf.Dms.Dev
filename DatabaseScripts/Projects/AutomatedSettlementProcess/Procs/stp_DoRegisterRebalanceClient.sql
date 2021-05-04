
ALTER procedure [dbo].[stp_DoRegisterRebalanceClient]
(
	@clientid int
)
as


-------------------------------------------------------------------------------
-- LOGIC FOR REBALANCING A CLIENT
-- (1) Loop through each transaction for a client
--     (a) Order first by TransactionDate
--     (b) Order second by RegisterID
-- (2) On each transaction add the current register amount to the balance of
--     the previous register and make that the new balance
--     (a) If OriginalAmount exists, use that instead of Amount
-- (3) Update SDABalance and PFOBalance
--     (a) If OriginalAmount exists, use that instead of Amount
------------------------------------------------------------------------------


-- discretionary variables
declare @date datetime
declare @type varchar (10)
declare @id int
declare @amount money
declare @bounceorvoid bit
declare @fee bit
declare @adjustment bit

declare @lastbalance money
declare @sdabalance money
declare @pfobalance money
declare @bankreserve money
declare @depositsonhold money
declare @minbankreserve money
declare @monthlyfee table (amount money)
declare @maintfee money

declare @transactions table
	(
		date datetime not null,
		[type] varchar (10) not null,
		id int not null,
		amount money not null,
		bounceorvoid bit not null,
		fee bit null,
		adjustment bit null
	)


-- bring all register records for this client into the transactions table
insert into
	@transactions
select
	transactiondate,
	'register',
	registerid,
	case when originalamount is null then amount else originalamount end,
	case when bounce is null and void is null then 0 else 1 end,
	tblentrytype.fee,
	case when adjustedregisterid is null then 0 else 1 end
from
	tblregister inner join
	tblentrytype on tblregister.entrytypeid = tblentrytype.entrytypeid
where
	clientid = @clientid


-- bring all payment records for this client into the transactions table
insert into
	@transactions
select
	rp.paymentdate,
	'payment',
	rp.registerpaymentid,
	rp.amount,
	case when rp.bounced = 0 and rp.voided = 0 then 0 else 1 end,
	null,
	null
from
	tblregisterpayment rp inner join
	tblregister r on rp.feeregisterid = r.registerid
where
	r.clientid = @clientid


-- initialize balances
set @lastbalance = 0
set @sdabalance = 0
set @pfobalance = 0

--select * from @transactions order by date, [type] desc, id

-- loop all clients transactions - order by date, then register-before-payments, then id
declare cursor_DoRegisterRebalanceClient cursor for
	select * from @transactions order by date, [type] desc, id

open cursor_DoRegisterRebalanceClient

fetch next from cursor_DoRegisterRebalanceClient into @date, @type, @id, @amount, @bounceorvoid, @fee, @adjustment
while @@fetch_status = 0

	begin

		if @type = 'register'
			begin

				-- only increment if not bounced or void
				if @bounceorvoid = 0
					begin
						set @lastbalance = @lastbalance + @amount

						if @fee = 1 or @adjustment = 1 -- increase pfo balance
							begin
								set @pfobalance = @pfobalance + (@amount * -1)
							end
						else
							begin
								set @sdabalance = @sdabalance + @amount
							end
					end

				-- only save to register table
				update
					tblregister
				set
					balance = @lastbalance,
					sdabalance = @sdabalance,
					pfobalance = @pfobalance
				where
					registerid = @id

			end
		else -- payment
			begin

				-- only increment if not bounced or void
				if @bounceorvoid = 0
					begin
						-- move amount from sda to pfo
						set @sdabalance = @sdabalance - @amount
						set @pfobalance = @pfobalance - @amount
					end

				-- only save to payment table
				update
					tblregisterpayment
				set
					sdabalance = @sdabalance,
					pfobalance = @pfobalance
				where
					registerpaymentid = @id

			end


		fetch next from cursor_DoRegisterRebalanceClient into @date, @type, @id, @amount, @bounceorvoid, @fee, @adjustment

	end

close cursor_DoRegisterRebalanceClient
deallocate cursor_DoRegisterRebalanceClient


-- Bank Reserve
select @minbankreserve = cast([value] as money) from tblproperty where name = 'MinBankReserve'

insert @monthlyfee exec stp_GetMonthlyFee @clientid

select @bankreserve = amount, @maintfee = amount from @MonthlyFee

if (@bankreserve < @minbankreserve) set @bankreserve = @minbankreserve


-- Deposits on hold
select @depositsonhold = isnull(sum(amount),0) 
from tblregister 
where entrytypeid = 3 -- deposit
and hold > getdate() 
and [clear] is null 
and void is null 
and bounce is null 
and clientid = @clientid


-- update the client's master balance fields
update
	tblclient
set
	sdabalance = @sdabalance - @depositsonhold,
	pfobalance = @pfobalance,
	bankreserve = @bankreserve,
	availablesda = @sdabalance - @pfobalance - @bankreserve - @depositsonhold,
	maintfee = @maintfee
where
	clientid = @clientid