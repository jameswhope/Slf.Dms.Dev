IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_DoRegisterPaymentVoid')
	BEGIN
		DROP  Procedure  stp_DoRegisterPaymentVoid
	END

GO

CREATE procedure stp_DoRegisterPaymentVoid
	(
		@registerpaymentid int,
		@docleanup bit = 1,
		@UserID int = 28
	)

as
Begin
declare @clientid int
declare @numcoms int set @numcoms = null


-- find and set the client on this register payment
select
	@clientid = r.clientid
from
	tblregister r inner join
	tblregisterpayment rp on r.registerid = rp.feeregisterid
where
	rp.registerpaymentid = @registerpaymentid

-- (e) If CheckSite client, credit their shadow store for payments made on this payment
insert tblNachaRegister2 ([Name],Amount,IsPersonal,CompanyID,ShadowStoreId,ClientID,TrustId,RegisterID,RegisterPaymentID,Flow)
select cp.ControlledAccountName,rp.Amount,0,c.CompanyID,c.AccountNumber,c.ClientID,c.TrustID,r.RegisterID,rp.RegisterPaymentId,'credit'
from tblRegisterPayment rp
join tblRegister r on r.RegisterID = rp.FeeRegisterID
join tblClient c on c.ClientID = r.ClientID and c.TrustID = 22
join tblCompany cp on cp.CompanyId = c.CompanyId
Where rp.RegisterPaymentID = @registerpaymentid
and rp.Voided <> 1 and rp.Bounced <> 1

-- void the payment
update
	tblregisterpayment
set
	voided = 1,
	voiddate = getdate(),
	modified = getdate(),
	modifiedBy = @UserID
where
	registerpaymentid = @registerpaymentid
	and voided = 0

update
	tblregisterpaymentdeposit
set
	voided = 1,
	voiddate = getdate(),
	modified = getdate(),
	modifiedBy = @UserID
where
	registerpaymentid = @registerpaymentid
	
-- determine if there are any commpay records issued for this payment already
select
	@numcoms = count(commpayid)
from
	tblcommpay
where
	registerpaymentid = @registerpaymentid


-- if comms exist, chargeback those only, otherwise reevaluate the entire payment for chargeback
if not @numcoms is null and @numcoms > 0
	begin
		exec stp_PayChargebackAmount @registerpaymentid
	end
else
	begin
		exec stp_PayChargebackPayment @registerpaymentid
	end


if @docleanup = 1
	begin
		exec stp_DoRegisterCleanup @clientid
	end
end

GO

