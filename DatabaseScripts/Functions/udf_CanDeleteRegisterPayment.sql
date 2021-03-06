/****** Object:  UserDefinedFunction [dbo].[udf_CanDeleteRegisterPayment]    Script Date: 11/19/2007 14:49:16 ******/
DROP FUNCTION [dbo].[udf_CanDeleteRegisterPayment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[udf_CanDeleteRegisterPayment]
	(
		@registerpaymentid int
	)

returns bit

begin

	declare @num int
	declare @result bit


	-- find all batched commission for this register payment
	select
		@num = isnull(count(cp.commpayid), 0)
	from
		tblcommpay cp inner join
		tblregisterpayment rp on cp.registerpaymentid = rp.registerpaymentid
	where
		rp.registerpaymentid = @registerpaymentid and
		not cp.commbatchid is null


	-- find all batched chargeback for this register (as having been paid)
	select
		@num = @num + isnull(count(cb.commchargebackid), 0)
	from
		tblcommchargeback cb inner join
		tblregisterpayment rp on cb.registerpaymentid = rp.registerpaymentid
	where
		rp.registerpaymentid = @registerpaymentid and
		not cb.commbatchid is null


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
