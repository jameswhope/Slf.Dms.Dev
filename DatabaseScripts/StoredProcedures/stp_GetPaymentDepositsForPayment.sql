/****** Object:  StoredProcedure [dbo].[stp_GetPaymentDepositsForPayment]    Script Date: 11/19/2007 15:27:12 ******/
DROP PROCEDURE [dbo].[stp_GetPaymentDepositsForPayment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetPaymentDepositsForPayment]
	(
		@registerpaymentid int
	)

as

declare @payments table
(
	RegisterPaymentDepositID int,
	RegisterPaymentID int,
	DepositRegisterID int,
	DepositRegisterEntryTypeID int,
	DepositRegisterEntryTypeName nvarchar(50),
	DepositRegisterTransactionDate datetime,
	DepositRegisterCheckNumber nvarchar(50),
	DepositRegisterAmount money,
	DepositRegisterIsFullyPaid bit,
	Amount money,
	Voided bit,
	Bounced bit,
	ClientID int,
	AccountID int,
	EntryTypeID int
)

insert into
	@payments
select
	tblregisterpaymentdeposit.registerpaymentdepositid,
	tblregisterpaymentdeposit.registerpaymentid,
	tblregisterpaymentdeposit.depositregisterid,
	tblregister.entrytypeid as depositregisterentrytypeid,
	tblentrytype.name as depositregisterentrytypename,
	tblregister.transactiondate as depositregistertransactiondate,
	tblregister.checknumber as depositregisterchecknumber,
	tblregister.amount as depositregisteramount,
	tblregister.isfullypaid as depositregisterisfullypaid,
	tblregisterpaymentdeposit.amount as amount,
	tblregisterpaymentdeposit.voided as voided,
	tblregisterpaymentdeposit.bounced as bounced,
	tblfeeregister.clientid as clientid,
	tblfeeregister.accountid as accountid,
	tblfeeregister.entrytypeid as entrytypeid
from
	tblregisterpaymentdeposit inner join
	tblregister on tblregisterpaymentdeposit.depositregisterid = tblregister.registerid inner join
	tblregisterpayment on tblregisterpayment.registerpaymentid = tblregisterpaymentdeposit.registerpaymentid inner join
	tblregister as tblfeeregister on tblfeeregister.registerid = tblregisterpayment.feeregisterid inner join
	tblentrytype on tblregister.entrytypeid = tblentrytype.entrytypeid
where
	tblregisterpaymentdeposit.registerpaymentid = @registerpaymentid
order by
	tblregister.transactiondate, tblregister.registerid

declare @clientid int
declare @accountid int
declare @secregisterpayid int

set @clientid = -1
set @accountid = -1
set @secregisterpayid = -1

select top 1
	@clientid = clientid,
	@accountid = accountid
from
	@payments
where
	entrytypeid = 42

if not @clientid = -1
begin
	select top 1
		@secregisterpayid = rp.registerpaymentid
	from
		tblregisterpayment as rp inner join
		tblregister as r on r.registerid = rp.feeregisterid
	where
		r.clientid = @clientid and
		r.accountid = @accountid and
		r.entrytypeid = 2

	if not @secregisterpayid = -1
	begin
		insert into
			@payments
		select
			tblregisterpaymentdeposit.registerpaymentdepositid,
			tblregisterpaymentdeposit.registerpaymentid,
			tblregisterpaymentdeposit.depositregisterid,
			tblregister.entrytypeid as depositregisterentrytypeid,
			tblentrytype.name as depositregisterentrytypename,
			tblregister.transactiondate as depositregistertransactiondate,
			tblregister.checknumber as depositregisterchecknumber,
			tblregister.amount as depositregisteramount,
			tblregister.isfullypaid as depositregisterisfullypaid,
			tblregisterpaymentdeposit.amount as amount,
			tblregisterpaymentdeposit.voided as voided,
			tblregisterpaymentdeposit.bounced as bounced,
			tblfeeregister.clientid as clientid,
			tblfeeregister.accountid as accountid,
			tblfeeregister.entrytypeid as entrytypeid
		from
			tblregisterpaymentdeposit inner join
			tblregister on tblregisterpaymentdeposit.depositregisterid = tblregister.registerid inner join
			tblregisterpayment on tblregisterpayment.registerpaymentid = tblregisterpaymentdeposit.registerpaymentid inner join
			tblregister as tblfeeregister on tblfeeregister.registerid = tblregisterpayment.feeregisterid inner join
			tblentrytype on tblregister.entrytypeid = tblentrytype.entrytypeid
		where
			tblregisterpaymentdeposit.registerpaymentid = @secregisterpayid
	end
end

select
	*
from
	@payments
GO
