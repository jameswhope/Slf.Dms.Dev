/****** Object:  StoredProcedure [dbo].[stp_DoRegisterVoid]    Script Date: 11/19/2007 15:27:03 ******/
DROP PROCEDURE [dbo].[stp_DoRegisterVoid]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_DoRegisterVoid]
	(
		@registerid int,
		@by int,
		@when datetime = null,
		@docleanup bit = 1
	)

as

if @when is null
	begin
		set @when = getdate()
	end

------------------------------------------------------------------------------------
-- LOGIC FOR VOIDING A REGISTER
-- (1) Mark register as void by updating fields
--     (a) Set void = @when value passed in
--     (b) Set voidby = @by value passed in
--     (c) Set any fee adjustments as bounced if associated to this register fee
--     (d) Set any register payments and deposits as voided if associated through 
--         the payment deposit or through the payment
-- (2) Check payments taken on this bounced deposits.  If any exist, issue 
--     commission chargeback
------------------------------------------------------------------------------------


-- (1) void register
update
	tblregister
set
	void = @when,
	voidby = @by
where
	registerid = @registerid or
	adjustedregisterid = @registerid


-- void any associated register payments as related to any payment deposits
update
	tblregisterpayment
set
	voided = 1
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


-- void any associated register payment deposits as related to any payment deposits
update
	tblregisterpaymentdeposit
set
	voided = 1
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


-- void any associated register payments as related to this register directly
update
	tblregisterpayment
set
	voided = 1
where
	feeregisterid = @registerid


-- void any associated register payment deposits as related to any payment
update
	tblregisterpaymentdeposit
set
	voided = 1
where
	registerpaymentid in
	(
		select
			registerpaymentid
		from
			tblregisterpayment
		where
			feeregisterid = @registerid
	)


-- (2) issue commission chargebacks
exec stp_PayChargeback @registerid


if @docleanup = 1
	begin
		-- find and set the client on this register
		declare @clientid int

		select
			@clientid = clientid
		from
			tblregister
		where
			registerid = @registerid

		exec stp_DoRegisterCleanup @clientid
	end

if (select entrytypeid from tblregister where registerid = @registerid) = -2
	begin
		exec stp_DoRegisterFixAdjustedFee @registerid
	end
GO
