
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PotentialPayFee')
	BEGIN
		DROP Procedure stp_PotentialPayFee
	END
GO 

create procedure [dbo].[stp_PotentialPayFee]
(
	@registerid int
)
as

set nocount on
set ansi_warnings off

--------------------------------------------------------------------------
-- LOGIC FOR FEE PAYMENT:
-- (1) Pay for whole fee with oldest deposits first
-- (2) Pay for as much of fee as possible as one payment.  Do
--      not make multiple payments against same fee
-- (3) Do not attempt to pay fee if IsFullyPaid = 1
-- (4) After fee is completely paid, set IsFullyPaid = 1 but only
--      if fully paid
--------------------------------------------------------------------------


-- discretionary variables
declare @clientid int
declare @feetotal money
declare @feepaid as money
declare @feeremaining money
declare @deposittotal money
declare @depositused money
declare @nonefeedebits money
declare @depositavailable money


-- (1) find and fill fee variables
select
	@clientid = r.clientid,
	@feetotal = coalesce(abs(r.amount), 0),
	@feepaid = coalesce(sum(rp.amount), 0)
from
	tblpotentialregistertmp r left join
	(
		select
			*
		from
			tblpotentialregisterpaymenttmp
	) rp on r.registerid = rp.feeregisterid
where
	registerid = @registerid
group by
	r.clientid,
	r.amount,
	r.isfullypaid


set @feeremaining = @feetotal - @feepaid


-- (2) find and fill deposit variables (includes projected checks, ach, and adhocs)
-- deposit total is every positive amount this client originally had minus
-- any deposits still on hold or deposits that were bounced or voided or have an adjustedregisterid
-- (adjustedregisterid means that the record is actually a fee adjustment)
select
	@deposittotal = coalesce(sum(amount), 0)
from
	tblpotentialregistertmp
where
	amount > 0 and
	clientid = @clientid and
	(
		hold is null or hold <= getdate() or [clear] <= getdate()
	)
	and adjustedregisterid is null


-- deposit used is every amount used in the paymentdeposit table by this
-- client (which will include parts of deposits that are not fully paid)
-- DO NOT INCLUDE deposits that were bounced or voided as there presence
-- will still remain in the paymentdeposit table
select
	@depositused = coalesce(sum(amount), 0)
from
	tblpotentialregisterpaymentdeposittmp
where
	depositregisterid in
	(
		select
			registerid
		from
			tblpotentialregistertmp
		where
			clientid = @clientid
	)


-- none-fee debits must also be subtracted from the deposit total
select
	@nonefeedebits = coalesce(sum(abs(amount)), 0)
from
	tblpotentialregistertmp
where
	clientid = @clientid and
	amount < 0 and
	fee = 0 and
	adjustedregisterid is null


set @depositavailable = @deposittotal - @depositused - @nonefeedebits
--print 'fee remaining ' + cast(@feeremaining as varchar(10)) + ' deposit avail ' + cast(@depositavailable as varchar(10)) + ' dep total ' + cast( @deposittotal as varchar(10)) + ' dep used ' + cast(@depositused as varchar(10)) + ' non fee deb ' + cast(@nonefeedebits as varchar(10))

-- (3) don't do anything if fee was already fully paid or if this client
-- doesn't have any available deposit
if @depositavailable > 0
	begin

		-- (4) determine state of fee remaining
		if @feeremaining > @depositavailable -- more fee then all deposit
			begin

				-- (a) take all available deposit for this payment
				exec stp_PotentialPayFeeAmount @registerid, @depositavailable, @clientid

				-- (b) do NOT set fee as fully paid

			end
		else if @feeremaining <= @depositavailable -- fee less or equals all deposit
			begin

				-- (a) take all deposit or all fee (which are the same thing)
				exec stp_PotentialPayFeeAmount @registerid, @feeremaining, @clientid

				-- (b) DO set fee as fully paid
				update tblpotentialregistertmp set isfullypaid = 1 where registerid = @registerid

			end

	end


set nocount off
set ansi_warnings on
GO