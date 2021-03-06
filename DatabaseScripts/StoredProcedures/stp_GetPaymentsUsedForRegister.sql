/****** Object:  StoredProcedure [dbo].[stp_GetPaymentsUsedForRegister]    Script Date: 11/19/2007 15:27:12 ******/
DROP PROCEDURE [dbo].[stp_GetPaymentsUsedForRegister]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetPaymentsUsedForRegister]
	(
		@registerid int
	)

as

-- find all paymentsregisters that were used for this register (which was a fee)
declare @payments table
(
	RegisterPaymentID int,
	PaymentDate datetime,
	FeeRegisterID int,
	FeeRegisterEntryTypeID int,
	FeeRegisterEntryTypeName nvarchar(50),
	FeeRegisterTransactionDate datetime,
	FeeRegisterCheckNumber nvarchar(50),
	FeeRegisterAmount money,
	FeeRegisterIsFullyPaid bit,
	Amount money,
	Voided bit,
	Bounced bit,
	RegisterPaymentDepositID int,
	DepositRegisterID int,
	DepositRegisterEntryTypeID int,
	DepositRegisterEntryTypeName nvarchar(50),
	DepositRegisterTransactionDate datetime,
	DepositRegisterCheckNumber nvarchar(50),
	DepositRegisterAmount money,
	DepositRegisterIsFullyPaid bit,
	RegisterPaymentDepositAmount money,
	RegisterPaymentDepositVoided bit,
	RegisterPaymentDepositBounced bit,
	FeeRegisterAccountID int,
	FeeRegisterClientID int
)

insert into
	@payments
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
	tblregisterpaymentdeposit.bounced as registerpaymentdepositbounced,
	tblfeeregister.accountid as feeregisteraccountid,
	tblfeeregister.clientid as feeregisterclientid
from
	tblregisterpayment inner join
	tblregister tblfeeregister on tblregisterpayment.feeregisterid = tblfeeregister.registerid inner join
	tblentrytype tblfeeentrytype on tblfeeregister.entrytypeid = tblfeeentrytype.entrytypeid inner join
	tblregisterpaymentdeposit on tblregisterpaymentdeposit.registerpaymentid = tblregisterpayment.registerpaymentid inner join
	tblregister tbldepositregister on tblregisterpaymentdeposit.depositregisterid = tbldepositregister.registerid inner join
	tblentrytype tbldepositentrytype on tbldepositregister.entrytypeid = tbldepositentrytype.entrytypeid
where
	tblregisterpayment.feeregisterid = @registerid
order by
	tblregisterpayment.paymentdate, tblregisterpayment.registerpaymentid


declare @clientid int
declare @accountid int
declare @entrytypeid int
declare @secregisterid int

set @clientid = -1
set @accountid = -1
set @entrytypeid = -1
set @secregisterid = -1

select top 1
	@clientid = feeregisterclientid,
	@accountid = feeregisteraccountid,
	@entrytypeid = feeregisterentrytypeid
from
	@payments
where
	feeregisterentrytypeid in (2, 42)

if not @clientid = -1
begin
	select top 1
		@secregisterid = registerid
	from
		tblregister
	where
		clientid = @clientid and
		accountid = @accountid and
		entrytypeid = (case @entrytypeid when 42 then 2 when 2 then 42 end)

	if not @secregisterid = -1
	begin
		insert into
			@payments
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
			tblregisterpaymentdeposit.bounced as registerpaymentdepositbounced,
			tblfeeregister.accountid as feeregisteraccountid,
			tblfeeregister.clientid as feeregisterclientid
		from
			tblregisterpayment inner join
			tblregister tblfeeregister on tblregisterpayment.feeregisterid = tblfeeregister.registerid inner join
			tblentrytype tblfeeentrytype on tblfeeregister.entrytypeid = tblfeeentrytype.entrytypeid inner join
			tblregisterpaymentdeposit on tblregisterpaymentdeposit.registerpaymentid = tblregisterpayment.registerpaymentid inner join
			tblregister tbldepositregister on tblregisterpaymentdeposit.depositregisterid = tbldepositregister.registerid inner join
			tblentrytype tbldepositentrytype on tbldepositregister.entrytypeid = tbldepositentrytype.entrytypeid
		where
			tblregisterpayment.feeregisterid = @secregisterid
	end
end

select
	*
from
	@payments
GO
