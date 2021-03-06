/****** Object:  StoredProcedure [dbo].[stp_DoRegisterPaymentVoid]    Script Date: 11/19/2007 15:27:02 ******/
DROP PROCEDURE [dbo].[stp_DoRegisterPaymentVoid]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_DoRegisterPaymentVoid]
	(
		@registerpaymentid int,
		@docleanup bit = 1
	)

as

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


-- void the payment
update
	tblregisterpayment
set
	voided = 1
where
	registerpaymentid = @registerpaymentid
	and voided = 0

update
	tblregisterpaymentdeposit
set
	voided = 1
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
GO
