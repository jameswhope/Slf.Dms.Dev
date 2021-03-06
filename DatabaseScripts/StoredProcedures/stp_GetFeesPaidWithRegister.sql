/****** Object:  StoredProcedure [dbo].[stp_GetFeesPaidWithRegister]    Script Date: 11/19/2007 15:27:09 ******/
DROP PROCEDURE [dbo].[stp_GetFeesPaidWithRegister]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetFeesPaidWithRegister]
	(
		@registerid int
	)

as


-- find all feeregisters that were paid with this register (which is a credit)
select
	tblregisterpayment.registerpaymentid,
	tblregisterpayment.paymentdate,
	tblregisterpayment.amount as registerpaymentamount,
	tblregister.*,
	tblentrytype.name as entrytypename
from
	tblregisterpayment inner join
	tblregister on tblregisterpayment.feeregisterid = tblregister.registerid inner join
	tblregisterpaymentdeposit on tblregisterpayment.registerpaymentid = tblregisterpaymentdeposit.registerpaymentid inner join
	tblentrytype on tblregister.entrytypeid = tblentrytype.entrytypeid
where
	tblregisterpaymentdeposit.depositregisterid = @registerid
order by
	tblregisterpayment.paymentdate
GO
