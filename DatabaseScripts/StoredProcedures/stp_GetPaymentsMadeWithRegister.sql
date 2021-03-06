/****** Object:  StoredProcedure [dbo].[stp_GetPaymentsMadeWithRegister]    Script Date: 11/19/2007 15:27:12 ******/
DROP PROCEDURE [dbo].[stp_GetPaymentsMadeWithRegister]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetPaymentsMadeWithRegister]
	(
		@registerid int
	)

as

select
	tblregisterpayment.registerpaymentid,
	tblregisterpayment.paymentdate,
	tblregisterpayment.feeregisterid,
	tblfeeregister.entrytypeid as feeregisterentrytypeid,
	tblfeeentrytype.name as feeregisterentrytypename,
	tblfeeregister.transactiondate as feeregistertransactiondate,
	tblfeeregister.checknumber as feeregisterchecknumber,
	tblfeeregister.amount as feeregisteramount,
	tblfeeregister.isfullypaid as feeregisterisfullypaid,
	tblregisterpayment.amount,
	tblregisterpayment.voided,
	tblregisterpayment.bounced,
	tblregisterpaymentdeposit.registerpaymentdepositid,
	tblregisterpaymentdeposit.depositregisterid,
	tbldepositregister.entrytypeid as depositregisterentrytypeid,
	tbldepositentrytype.name as depositregisterentrytypename,
	tbldepositregister.transactiondate as depositregistertransactiondate,
	tbldepositregister.checknumber as depositregisterchecknumber,
	tbldepositregister.amount as depositregisteramount,
	tbldepositregister.isfullypaid as depositregisterisfullypaid,
	tblregisterpaymentdeposit.amount as registerpaymentdepositamount,
	tblregisterpaymentdeposit.voided as registerpaymentdepositvoided,
	tblregisterpaymentdeposit.bounced as registerpaymentdepositbounced
from
	tblregisterpayment inner join
	tblregister tblfeeregister on tblregisterpayment.feeregisterid = tblfeeregister.registerid inner join
	tblentrytype tblfeeentrytype on tblfeeregister.entrytypeid = tblfeeentrytype.entrytypeid inner join
	tblregisterpaymentdeposit on tblregisterpaymentdeposit.registerpaymentid = tblregisterpayment.registerpaymentid inner join
	tblregister tbldepositregister on tblregisterpaymentdeposit.depositregisterid = tbldepositregister.registerid inner join
	tblentrytype tbldepositentrytype on tbldepositregister.entrytypeid = tbldepositentrytype.entrytypeid
where
	tblregisterpayment.registerpaymentid in
	(
		select
			registerpaymentid
		from
			tblregisterpaymentdeposit
		where
			depositregisterid = @registerid
	)
order by
	tblregisterpayment.paymentdate, tblregisterpayment.registerpaymentid
GO
