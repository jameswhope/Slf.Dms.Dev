
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PotentialPayFeeAmount')
	BEGIN
		DROP Procedure stp_PotentialPayFeeAmount
	END
GO 
 
create procedure [dbo].[stp_PotentialPayFeeAmount]
(
	@registerid int,
	@amount money,
	@clientid int
)
as

---------------------------------------------------------------------
-- LOGIC FOR TAKING AMOUNT:
-- (1) Insert register payment record against this fee
-- (2) Loop not-totally-used deposits, oldest first, for this
--      client; and insert register payment deposit records
--      finalizing each deposit that is completely used
--      (a) Do not use deposits marked VOID
--      (b) Do not use deposits marked BOUNCE
--      (c) deposits must be greater then 0
--      (d) deposits cannot be on hold
--      (e) records cannot have an adjustedrecordid (means record
--          is actually a fee adjustment record)
-- (3) Check fee, when finished, to determine if isfullypaid
--      should be set
-- (4) Pay commission
---------------------------------------------------------------------


-- discretionary variables
declare @registerpaymentid int
declare @depositid int
declare @depositneeded money
declare @deposittotal money
declare @depositalreadyused money
declare @deposithasleft money


-- (2) insert a register payment record against this fee for the full amount
insert tblpotentialregisterpaymenttmp
(
	paymentdate,
	feeregisterid,
	amount,
	pfobalance,
	sdabalance
)
values
(
	getdate(),
	@registerid,
	@amount,
	0,
	0
)

select @registerpaymentid = scope_identity()


-- (4) reset deposit needed to entire amount
set @depositneeded = @amount


-- (5) while full amount has not been used by a deposit loop and get
while @depositneeded > 0
	begin

		-- (a) find the first not-totally-used deposit for this client in the register
		-- that isn't on hold, bounced or voided, or a fee adjustment
		select top 1 @depositid = registerid 
		from tblpotentialregistertmp
		where
			isfullypaid = 0 and
			clientid = @clientid and
			adjustedregisterid is null and
			amount > 0 and
			(
				hold is null or hold <= getdate() or [clear] <= getdate()
			)
		order by
			transactiondate, registerid

		if not @depositid is null -- found an available deposit
			begin

				-- (b) determine the original total amount of deposit
				select
					@deposittotal = coalesce(amount, 0)
				from
					tblpotentialregistertmp
				where
					registerid = @depositid


				-- (c) determine how much deposit already spent and has left now
				--     but do not include any bounced or voided payment deposits
				select
					@depositalreadyused = coalesce(sum(amount), 0)
				from
					tblpotentialregisterpaymentdeposittmp
				where
					depositregisterid = @depositid


				set @deposithasleft = @deposittotal - @depositalreadyused
				--print 'deposit needed ' + cast(@depositneeded as varchar(10)) + ' dep has left ' + cast(@deposithasleft as varchar(10))

				-- (d) determine what deposit has in relation
				if @deposithasleft < @depositneeded -- too little, we need more
					begin
						-- insert payment deposit (taking only what was left)
						insert tblpotentialregisterpaymentdeposittmp
						(
							registerpaymentid,
							depositregisterid,
							amount
						)
						values
						(
							@registerpaymentid,
							@depositid,
							@deposithasleft
						)

						-- subtract deposit used from needed
						set @depositneeded = @depositneeded - @deposithasleft

						-- set deposit as fully paid out
						update
							tblpotentialregistertmp
						set
							isfullypaid = 1
						where
							registerid = @depositid

					end
				else if @deposithasleft = @depositneeded -- exactly enough
					begin
						-- insert payment deposit (taking everything left)
						insert tblpotentialregisterpaymentdeposittmp
						(
							registerpaymentid,
							depositregisterid,
							amount
						)
						values
						(
							@registerpaymentid,
							@depositid,
							@deposithasleft
						)

						-- subtract deposit used from needed
						set @depositneeded = @depositneeded - @deposithasleft

						-- set deposit as fully paid out
						update
							tblpotentialregistertmp
						set
							isfullypaid = 1
						where
							registerid = @depositid

					end
				else if @deposithasleft > @depositneeded -- too much, will have leftovers
					begin
						-- insert payment deposit (taking only deposit needed)
						insert tblpotentialregisterpaymentdeposittmp
						(
							registerpaymentid,
							depositregisterid,
							amount
						)
						values
						(
							@registerpaymentid,
							@depositid,
							@depositneeded
						)

						-- subtract deposit used from needed
						set @depositneeded = @depositneeded - @depositneeded

					end
			end
		else -- did NOT find available deposit
			begin
				-- just exit loop (THIS SHOULD NEVER HAPPEN - there should always
				-- be enough deposit before getting here)
				break
			end

	end -- while loop


-- (6) Pay commission
exec stp_PotentialPayCommission @registerpaymentid, @clientid