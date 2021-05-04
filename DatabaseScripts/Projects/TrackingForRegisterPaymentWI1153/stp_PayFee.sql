IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PayFee')
	BEGIN
		DROP  Procedure  stp_PayFee
	END

GO

CREATE Procedure stp_PayFee
(
		@registerid int,
		@hidemessages bit = 1,
		@UserID int = 28
	)

AS

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
declare @feeisfullypaid bit

--declare @adjustmentstotal money

declare @deposittotal money
declare @depositused money
declare @nonefeedebits money
declare @depositavailable money


-- (1) find and fill fee variables
select
	@clientid = tblregister.clientid,
	@feetotal = coalesce(abs(tblregister.amount), 0),
	@feepaid = coalesce(sum(tblregisterpayment.amount), 0),
	@feeisfullypaid = tblregister.isfullypaid
from
	tblregister left join
	(
		select
			*
		from
			tblregisterpayment
		where
			voided = 0 and
			bounced = 0
	)
	tblregisterpayment on tblregister.registerid = tblregisterpayment.feeregisterid
where
	registerid = @registerid
group by
	tblregister.clientid,
	tblregister.amount,
	tblregister.isfullypaid

set @feeremaining = @feetotal - @feepaid


-- (2) find and fill deposit variables
-- deposit total is every positive amount this client originally had minus
-- any deposits still on hold or deposits that were bounced or voided or have an adjustedregisterid
-- (adjustedregisterid means that the record is actually a fee adjustment)
select
	@deposittotal = coalesce(sum(amount), 0)
from
	tblregister
where
	amount > 0 and
	clientid = @clientid and
	(
		hold is null or hold <= getdate() or [clear] <= getdate()
	)
	and bounce is null
	and void is null
	and adjustedregisterid is null


-- deposit used is every amount used in the paymentdeposit table by this
-- client (which will include parts of deposits that are not fully paid)
-- DO NOT INCLUDE deposits that were bounced or voided as there presence
-- will still remain in the paymentdeposit table
select
	@depositused = coalesce(sum(amount), 0)
from
	tblregisterpaymentdeposit
where
	depositregisterid in
	(
		select
			registerid
		from
			tblregister
		where
			clientid = @clientid
	)
	and bounced = 0
	and voided = 0


-- none-fee debits must also be subtracted from the deposit total
select
	@nonefeedebits = coalesce(sum(abs(amount)), 0)
from
	tblregister inner join
	tblentrytype on tblregister.entrytypeid = tblentrytype.entrytypeid
where
	clientid = @clientid and
	amount < 0 and
	tblentrytype.fee = 0 and
	void is null and
	bounce is null and
	adjustedregisterid is null


set @depositavailable = @deposittotal - @depositused - @nonefeedebits

if @hidemessages = 0
	begin
		print 'fee:' + convert(varchar(50), @feetotal) + ', paid:' + convert(varchar(50), @feepaid) + ', remaining:' + convert(varchar(50), @feeremaining) + ', non-fee debits:' + convert(varchar(50), @nonefeedebits) + ', deposits:' + convert(varchar(50), @deposittotal) + ', used:' + convert(varchar(50), @depositused) + ', available:' + convert(varchar(50), @depositavailable)
	end


-- (3) don't do anything if fee was already fully paid or if this client
-- doesn't have any available deposit
if @feeisfullypaid = 0 and @depositavailable > 0
	begin

		-- (4) determine state of fee remaining
		if @feeremaining > @depositavailable -- more fee then all deposit
			begin

				-- (a) take all available deposit for this payment
				exec stp_PayFeeAmount @registerid, @depositavailable, @UserID

				-- (b) do NOT set fee as fully paid

			end
		else if @feeremaining = @depositavailable -- fee equals all deposit,
			begin

				-- (a) take all deposit or all fee (which are the same thing)
				exec stp_PayFeeAmount @registerid, @feeremaining, @UserID

				-- (b) DO set fee as fully paid
				update tblregister set isfullypaid = 1 where registerid = @registerid

			end
		else if @feeremaining < @depositavailable -- less fee then all deposit
			begin

				-- (a) take only all fee
				exec stp_PayFeeAmount @registerid, @feeremaining, @UserID

				-- (b) DO set fee as fully paid
				update tblregister set isfullypaid = 1 where registerid = @registerid

			end

	end


set nocount off
set ansi_warnings on
GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

