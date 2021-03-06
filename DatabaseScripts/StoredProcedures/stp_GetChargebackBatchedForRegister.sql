/****** Object:  StoredProcedure [dbo].[stp_GetChargebackBatchedForRegister]    Script Date: 11/19/2007 15:27:04 ******/
DROP PROCEDURE [dbo].[stp_GetChargebackBatchedForRegister]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetChargebackBatchedForRegister]
	(
		@registerid int
	)

as

declare @numchargeback int
declare @sumchargeback money


-- find all batched chargeback for this register (as having been paid)
select
	@numchargeback = isnull(count(cb.commchargebackid), 0),
	@sumchargeback = isnull(sum(cb.amount), 0)
from
	tblcommchargeback cb inner join
	tblregisterpayment rp on cb.registerpaymentid = rp.registerpaymentid
where
	rp.feeregisterid = @registerid and
	not cb.commbatchid is null


-- find all batched chargeback for this register (as used for payment)
select
	@numchargeback = @numchargeback + isnull(count(cb.commchargebackid), 0),
	@sumchargeback = @sumchargeback + isnull(sum(cb.amount), 0)
from
	tblcommchargeback cb inner join
	tblregisterpaymentdeposit rpd on cb.registerpaymentid = rpd.registerpaymentid
where
	rpd.depositregisterid = @registerid and
	not cb.commbatchid is null


-- return values
select
	@numchargeback as numchargeback,
	@sumchargeback as sumchargeback
GO
