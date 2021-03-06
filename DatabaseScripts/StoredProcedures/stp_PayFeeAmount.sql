/****** Object:  StoredProcedure [dbo].[stp_PayFeeAmount]    Script Date: 11/19/2007 15:27:27 ******/
DROP PROCEDURE [dbo].[stp_PayFeeAmount]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_PayFeeAmount]
	(
		@registerid int,
		@amount money
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
declare @clientid int
declare @registerpaymentid int

declare @depositid int
declare @depositneeded money
declare @deposittotal money
declare @depositalreadyused money
declare @deposithasleft money


-- (1) find and set client for this fee
select @clientid = clientid from tblregister where registerid = @registerid


-- (2) insert a register payment record against this fee for the full amount
insert into tblregisterpayment
(
	paymentdate,
	feeregisterid,
	amount
)
values
(
	getdate(),
	@registerid,
	@amount
)


-- (3) grab newly-inserted register payment
set @registerpaymentid = scope_identity()


-- (4) reset deposit needed to entire amount
set @depositneeded = @amount


-- (5) while full amount has not been used by a deposit loop and get
while @depositneeded > 0
	begin

		-- (a) find the first not-totally-used deposit for this client in the register
		-- that isn't on hold, bounced or voided, or a fee adjustment
		select top 1 @depositid = registerid from tblregister
		where
			isfullypaid = 0 and
			void is null and
			bounce is null and
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
					tblregister
				where
					registerid = @depositid


				-- (c) determine how much deposit already spent and has left now
				--     but do not include any bounced or voided payment deposits
				select
					@depositalreadyused = coalesce(sum(amount), 0)
				from
					tblregisterpaymentdeposit
				where
					depositregisterid = @depositid and
					voided = 0 and
					bounced = 0


				set @deposithasleft = @deposittotal - @depositalreadyused

				-- (d) determine what deposit has in relation
				if @deposithasleft < @depositneeded -- too little, we need more
					begin

						-- insert payment deposit (taking only what was left)
						insert into tblregisterpaymentdeposit
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
							tblregister
						set
							isfullypaid = 1
						where
							registerid = @depositid

					end
				else if @deposithasleft = @depositneeded -- exactly enough
					begin

						-- insert payment deposit (taking everything left)
						insert into tblregisterpaymentdeposit
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
							tblregister
						set
							isfullypaid = 1
						where
							registerid = @depositid

					end
				else if @deposithasleft > @depositneeded -- too much, will have leftovers
					begin

						-- insert payment deposit (taking only deposit needed)
						insert into tblregisterpaymentdeposit
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
exec stp_PayCommission @registerpaymentid
GO
