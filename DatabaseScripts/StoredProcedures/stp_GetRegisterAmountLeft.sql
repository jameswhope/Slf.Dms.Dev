/****** Object:  StoredProcedure [dbo].[stp_GetRegisterAmountLeft]    Script Date: 11/19/2007 15:27:14 ******/
DROP PROCEDURE [dbo].[stp_GetRegisterAmountLeft]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetRegisterAmountLeft]
	(
		@registerid int
	)

as


---------------------------------------------------------------------
-- LOGIC FOR GETTING AMOUNT OF REGISTER LEFT TO BE USED FOR PAYMENTS
-- (1) Amount is the difference between the original entire 
--     credit and what has been allocated against payments already
-- (2) Don't return any register that is not available according
--     to the availablility rules
--      (a) Do not use credit marked VOID
--      (b) Do not use credit marked BOUNCE
--      (c) Credits must be greater then 0
--      (d) Credits cannot be on hold
----------------------------------------------------------------------


select
	coalesce(tblregister.amount, 0) - coalesce(sum(tblregisterpaymentdeposit.amount), 0) as amount
from
	tblregister left outer join
	(
		select
			*
		from
			tblregisterpaymentdeposit
		where
			voided = 0 and
			bounced = 0
	)
	as tblregisterpaymentdeposit ON tblregister.registerid = tblregisterpaymentdeposit.depositregisterid
where
	tblregister.amount > 0 and
	tblregister.isfullypaid = 0 and
	tblregister.void is null and
	tblregister.bounce is null and
	tblregister.registerid = @registerid and
	(
		hold is null or hold <= getdate() or clear <= getdate()
	)
group by
	tblregister.amount
GO
