/****** Object:  UserDefinedFunction [dbo].[udf_CanDeleteRegister]    Script Date: 11/19/2007 14:49:16 ******/
DROP FUNCTION [dbo].[udf_CanDeleteRegister]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[udf_CanDeleteRegister]
	(
		@registerid int
	)

returns bit

begin

	declare @num int
	declare @result bit

	-- find all batched commission for this register (as having been paid)
	select
		@num = isnull(count(cp.commpayid), 0)
	from
		tblcommpay cp inner join
		tblregisterpayment rp on cp.registerpaymentid = rp.registerpaymentid
	where
		rp.feeregisterid = @registerid and
		not cp.commbatchid is null


	-- find all batched commission for this register (as used for payment)
	select
		@num = @num + isnull(count(cp.commpayid), 0)
	from
		tblcommpay cp inner join
		tblregisterpaymentdeposit rpd on cp.registerpaymentid = rpd.registerpaymentid
	where
		rpd.depositregisterid = @registerid and
		not cp.commbatchid is null


	-- find all batched chargeback for this register (as having been paid)
	select
		@num = @num + isnull(count(cb.commchargebackid), 0)
	from
		tblcommchargeback cb inner join
		tblregisterpayment rp on cb.registerpaymentid = rp.registerpaymentid
	where
		rp.feeregisterid = @registerid and
		not cb.commbatchid is null


	-- find all batched chargeback for this register (as used for payment)
	select
		@num = @num + isnull(count(cb.commchargebackid), 0)
	from
		tblcommchargeback cb inner join
		tblregisterpaymentdeposit rpd on cb.registerpaymentid = rpd.registerpaymentid
	where
		rpd.depositregisterid = @registerid and
		not cb.commbatchid is null


	-- --------------------------------------------------------------------------------------------------------------
	-- Hotfix 1/15/10 jhernandez - Check tblNachaRegister2
	-- Disbursement account transactions aren't getting picked up by the above checks. As a result, transactions
	-- with orphan register ids end up in tblNachaRegister2. Currently have been just manually deleting them
	-- from tblNachaRegister2 when they show up as Warnings in the Daily Processing Log. Disbursement transfers that 
	-- have already been batched can only be voided.
	
	-- find all items in nacharegister2 associated with this registerid that have already been batched
	select 
		@num = @num + isnull(count(nacharegisterid), 0)
	from
		tblnacharegister2
	where 
		registerid = @registerid and
		name = 'Disbursement Account' and
		nachafileid > 0
	-- --------------------------------------------------------------------------------------------------------------
		

	if @num = 0
		begin
			select @result = convert(bit, 1)
		end
	else
		begin
			select @result = convert(bit, 0)
		end


	return @result
end
GO
