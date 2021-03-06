/****** Object:  StoredProcedure [dbo].[stp_DeleteRegisterPayment]    Script Date: 11/19/2007 15:27:00 ******/
DROP PROCEDURE [dbo].[stp_DeleteRegisterPayment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_DeleteRegisterPayment]
	(
		@registerpaymentid int,
		@docleanup bit = 1
	)

as


-- discretionary variables
declare @registerpaymentdepositid int
declare @clientid int


-- find client now, before the register payment is deleted
select
	@clientid = r.clientid
from
	tblregisterpayment rp inner join
	tblregister r on rp.feeregisterid = r.registerid
where
	rp.registerpaymentid = @registerpaymentid


-- delete any commission payments
delete
from
	tblcommpay
where
	registerpaymentid = @registerpaymentid


-- delete any commission chargebacks
delete
from
	tblcommchargeback
where
	registerpaymentid = @registerpaymentid


-- delete any register payment deposits
delete
from
	tblregisterpaymentdeposit
where
	registerpaymentid = @registerpaymentid


-- delete all attachment relationships
exec stp_DeleteRelation 5, @registerpaymentid


-- delete the register payment
delete
from
	tblregisterpayment
where
	registerpaymentid = @registerpaymentid
	
	
-- if the payment was batched but not sent, its no longer needed so delete it
-- applies to checksite clients only
delete
from 
	tblnacharegister2
where
	nachafileid = -1
	and registerpaymentid = @registerpaymentid

	
-- or if the payment was already sent, credit the shadow store
insert tblNachaRegister2
	(NachaFileId, [Name], Amount, IsPersonal, CompanyID, ShadowStoreId, ClientID, TrustId, RegisterID, RegisterPaymentID, Created, Flow)
select 
	-1, [Name], Amount, IsPersonal, CompanyID, ShadowStoreId, ClientID, TrustId, RegisterID, -1, getdate(), 'credit'
from 
	tblnacharegister2
where
	nachafileid > 0
	and registerpaymentid = @registerpaymentid


if @docleanup = 1
	begin
		exec stp_DoRegisterCleanup @clientid
	end
GO
