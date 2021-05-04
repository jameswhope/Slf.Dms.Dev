IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_DoRegisterVoid')
	BEGIN
		DROP  Procedure  stp_DoRegisterVoid
	END

GO

CREATE procedure stp_DoRegisterVoid
	(
		@registerid int,
		@by int = 28,
		@when datetime = null,
		@docleanup bit = 1
	)

as
Begin
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
--	   (e) If CheckSite client, credit their shadow store for payments made on this register entry
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
	
	
-- (e) If CheckSite client, credit their shadow store for payments made on this deposit
insert tblNachaRegister2 ([Name],Amount,IsPersonal,CompanyID,ShadowStoreId,ClientID,TrustId,RegisterID,RegisterPaymentID,Flow)
select cp.ControlledAccountName,rp.Amount,0,c.CompanyID,c.AccountNumber,c.ClientID,c.TrustID,r.RegisterID,rp.RegisterPaymentId,'credit'
from tblRegisterPayment rp
join tblRegisterPaymentDeposit d on d.RegisterPaymentID = rp.RegisterPaymentID
	and d.DepositRegisterID = @registerid
join tblRegister r on r.RegisterID = rp.FeeRegisterID
join tblClient c on c.ClientID = r.ClientID and c.TrustID = 22
join tblCompany cp on cp.CompanyId = c.CompanyID
Where rp.Voided <> 1 and rp.Bounced <> 1


-- void any associated register payments as related to any payment deposits
update
	tblregisterpayment
set
	voided = 1,
	VoidDate = getdate(),
	Modified = getdate(),
	ModifiedBy = @by
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
	voided = 1,
	VoidDate = getdate(),
	Modified = getdate(),
	ModifiedBy = @by
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
	
-- (e) If CheckSite client, credit their shadow store for payments made on this fee
insert tblNachaRegister2 ([Name],Amount,IsPersonal,CompanyID,ShadowStoreId,ClientID,TrustId,RegisterID,RegisterPaymentID,Flow)
select cp.ControlledAccountName,rp.Amount,0,c.CompanyID,c.AccountNumber,c.ClientID,c.TrustID,r.RegisterID,rp.RegisterPaymentId,'credit'
from tblRegisterPayment rp
join tblRegister r on r.RegisterID = rp.FeeRegisterID and rp.FeeRegisterID = @registerid
join tblClient c on c.ClientID = r.ClientID and c.TrustID = 22	
join tblCompany cp on cp.CompanyID = c.CompanyID
Where rp.Voided <> 1 and rp.Bounced <> 1



-- void any associated register payments as related to this register directly
update
	tblregisterpayment
set
	voided = 1,
	VoidDate = getdate(),
	Modified = getdate(),
	ModifiedBy = @by
where
	feeregisterid = @registerid


-- void any associated register payment deposits as related to any payment
update
	tblregisterpaymentdeposit
set
	voided = 1,
	VoidDate = getdate(),
	Modified = getdate(),
	ModifiedBy = @by
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

		exec stp_DoRegisterCleanup @clientid, @by
	end

if (select entrytypeid from tblregister where registerid = @registerid) = -2
	begin
		exec stp_DoRegisterFixAdjustedFee @registerid, @doCleanUp, @by
	end
end
GO

