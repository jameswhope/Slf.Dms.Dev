/****** Object:  StoredProcedure [dbo].[stp_GetCommissionBatchedForRegister]    Script Date: 11/19/2007 15:27:06 ******/
DROP PROCEDURE [dbo].[stp_GetCommissionBatchedForRegister]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetCommissionBatchedForRegister]
	(
		@registerid int
	)

as

declare @numcommission int
declare @sumcommission money


-- find all batched commission for this register (as having been paid)
select
	@numcommission = isnull(count(cp.commpayid), 0),
	@sumcommission = isnull(sum(cp.amount), 0)
from
	tblcommpay cp inner join
	tblregisterpayment rp on cp.registerpaymentid = rp.registerpaymentid
where
	rp.feeregisterid = @registerid and
	not cp.commbatchid is null


-- find all batched commission for this register (as used for payment)
select
	@numcommission = @numcommission + isnull(count(cp.commpayid), 0),
	@sumcommission = @sumcommission + isnull(sum(cp.amount), 0)
from
	tblcommpay cp inner join
	tblregisterpaymentdeposit rpd on cp.registerpaymentid = rpd.registerpaymentid
where
	rpd.depositregisterid = @registerid and
	not cp.commbatchid is null


-- return values
select
	@numcommission as numcommission,
	@sumcommission as sumcommission
GO
