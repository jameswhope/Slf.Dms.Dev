/****** Object:  StoredProcedure [dbo].[stp_GetRegisterAmountUsed]    Script Date: 11/19/2007 15:27:14 ******/
DROP PROCEDURE [dbo].[stp_GetRegisterAmountUsed]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetRegisterAmountUsed]
	(
		@registerid int
	)

as

select
	abs(tblregister.amount) - coalesce(sum(tblregisterpayment.amount),0) as amount
from
	tblregister left outer join
	(
		select
			*
		from
			tblregisterpayment
		where
			voided = 0 and
			bounced = 0
	)
	as tblregisterpayment on tblregister.registerid = tblregisterpayment.feeregisterid
where
	tblregister.registerid = @registerid
group by
	tblregister.amount
GO
