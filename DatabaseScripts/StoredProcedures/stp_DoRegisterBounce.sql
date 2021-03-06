/****** Object:  StoredProcedure [dbo].[stp_DoRegisterBounce]    Script Date: 11/19/2007 15:27:00 ******/
DROP PROCEDURE [dbo].[stp_DoRegisterBounce]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_DoRegisterBounce]
	(
		@registerid int,
		@by int,
		@collectfee bit = 1,
		@when datetime = null,
		@docleanup bit = 1,
		@BouncedReason int = 0
	)

as

if @when is null
	begin
		set @when = getdate()
	end

----------------------------------------------------------------------------------
-- LOGIC FOR BOUNCING A REGISTER
-- (1) Mark register as bounced by updating fields
--     (a) Set bounce = @when value is passed in
--     (b) Set bounceby = @by value is passed in
--			(b1) Set BouncedReason (code) = @Reason value is passed in
--     (c) Set any fee adjustments as bounced if associated to this register fee
--     (d) Set any register payments and deposits as bounced if associated
--         through the payment deposit
-- (2) If supose to, collect returned check fee
-- (3) check payments taken on this bounced deposits.  If any exist, issue
--     commission chargeback
----------------------------------------------------------------------------------


-- (1) bounce register
update
	tblregister
set
	bounce = @when,
	bounceby = @by,
	BouncedReason = @BouncedReason
where
	registerid = @registerid or
	adjustedregisterid = @registerid


-- bounce any associated register payments as related to any payment deposits
update
	tblregisterpayment
set
	bounced = 1
where
	registerpaymentid in
	(
		select
			registerpaymentid
		from
			tblregisterpaymentdeposit
		where
			depositregisterid = @registerid
	)


-- bounce any associated register payment deposits as related to any paymentd deposits
update
	tblregisterpaymentdeposit
set
	bounced = 1
where
	registerpaymentid in
	(
		select
			registerpaymentid
		from
			tblregisterpaymentdeposit
		where
			depositregisterid = @registerid
	)


-- (2) collect returned check fee
declare @clientid int
declare @returnedcheckfee money

-- find and set the client on this register
select
	@clientid = clientid
from
	tblregister
where
	registerid = @registerid

-- find and set fee amount for this client
select
	@returnedcheckfee = returnedcheckfee
from
	tblclient
where
	clientid = @clientid

if not @returnedcheckfee is null and @returnedcheckfee > 0 and @collectfee = 1
	begin

		-- insert the fee
		insert into tblregister
		(
			clientid,
			transactiondate,
			amount,
			entrytypeid
		)
		values
		(
			@clientid,
			@when,
			(@returnedcheckfee * -1),
			5 -- entrytypeid 5: returned check fee
		)

	end


-- (3) issue commission chargebacks
exec stp_PayChargeback @registerid


if @docleanup = 1
	begin
		exec stp_DoRegisterCleanup @clientid
	end
GO
