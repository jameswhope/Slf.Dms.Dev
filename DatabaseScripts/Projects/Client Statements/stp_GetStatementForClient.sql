IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetStatementForClient')
	BEGIN
		DROP  Procedure  stp_GetStatementForClient
	END

GO

CREATE procedure [dbo].[stp_GetStatementForClient]

@clientid int

as

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
declare @StmtPeriod NVARCHAR(50)
--declare @ClientID int
--SET @ClientID = 26928

IF DATEPART(DAY, GETDATE()) <= 15
	BEGIN
		SET @StmtPeriod = LEFT(CONVERT(VARCHAR(10), GETDATE(), 0),3) + '1_' 
		+ LEFT(CONVERT(VARCHAR(10), GETDATE(), 0),3) + '15_' + CONVERT(VARCHAR(4), DATEPART(YEAR, GETDATE()),0)
	END
IF DATEPART(DAY, GETDATE()) >= 16 
	BEGIN
		SET @StmtPeriod = LEFT(CONVERT(VARCHAR(10), GETDATE(), 0),3) + '16_' + LEFT(CONVERT(VARCHAR(10), GETDATE(), 0),3) 
		+ CAST(DATEPART(DAY, DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH , 0,GETDATE())+1 , 0))) AS VARCHAR(10)) + '_' + CONVERT(VARCHAR(4), DATEPART(YEAR, GETDATE()),0)
	END

select
	@clientid as ClientID,
	tcl.AccountNumber as ClientNumber,
	0 as registerfirst,
    r.registerid as id,
	r.transactiondate as date,
	r.checknumber,
	r.entrytypeid,
	et.[name] as entrytypename,
	r.originalamount,
	r.amount,
	r.sdabalance,
	r.pfobalance,
	r.description,
	r.accountid,
	c.name as accountcreditorname,
	ci.accountnumber,
	a.currentamount as accountcurrentamount,
	r.adjustedregisterid,
	ar.transactiondate as adjustedregistertransactiondate,
	ar.amount as adjustedregisteramount,
	ar.originalamount as adjustedregisteroriginalamount,
	ar.entrytypeid as adjustedregisterentrytypeid,
	--aret.name as adjustedregisterentrytypename,
	ar.accountid as adjustedregisteraccountid,
	arc.name as adjustedregisteraccountcreditorname,
	arci.accountnumber as adjustedregisteraccountnumber,
	r.achmonth,
	r.achyear,
	r.feemonth,
	r.feeyear,
	case when r.bounce is null and r.void is null then 0 else 1 end as bouncedorvoided,
	n.numnotes,
    pc.numphonecalls,
	@StmtPeriod AS [StmtPeriod]

into #tempresults

from
	tblregister r
	inner join tblentrytype et on r.entrytypeid = et.entrytypeid 
	left join tblClient tcl on r.ClientID = tcl.ClientID
	left join tblaccount a on r.accountid = a.accountid 
	left join tblcreditorinstance ci on a.originalcreditorinstanceid = ci.creditorinstanceid 
	left join tblcreditor c on ci.creditorid = c.creditorid 
	left join tblregister ar on r.adjustedregisterid = ar.registerid 
	left join tblaccount ara on ar.accountid = ara.accountid 
	left join tblcreditorinstance arci on ara.originalcreditorinstanceid = arci.creditorinstanceid 
	left join tblcreditor arc on arci.creditorid = arc.creditorid 
	left join tblentrytype aret on ar.entrytypeid = aret.entrytypeid 
	left join
	(
		select count(distinct noteid) as numnotes, relationid
		from tblnoterelation
		where relationtypeid = 4
		group by relationid
	)
	as n on r.registerid = n.relationid left join
	(
		select count(distinct phonecallid) as numphonecalls, relationid
		from tblphonecallrelation
		where relationtypeid = 4
		group by relationid
	)
	as pc on r.registerid = pc.relationid
	where r.ClientID = @clientid
	and (r.Bounce IS NULL 
	and r.Void IS NULL)
union all
select
	@clientid as ClientID,
	tcl.AccountNumber as ClientNumber,
	1 as registerfirst,
    rp.registerpaymentid as id,
    rp.paymentdate as date,
    '' as checknumber,
    -1 as entrytypeid,
    'Payment' as entrytypename,
    null as originalamount,
    rp.amount,
    rp.sdabalance,
    rp.pfobalance,
    null as description,
    null as accountid,
    null as accountcreditorname,
    null as accountnumber,
    null as accountcurrentamount,
    r.registerid as adjustedregisterid,
    r.transactiondate as adjustedregistertransactiondate,
    r.amount as adjustedregisteramount,
    r.originalamount as adjustedregisteroriginalamount,
    r.entrytypeid as adjustedregisterentrytypeid,
    --ret.name as adjustedregisterentrytypename,
    r.accountid as adjustedregisteraccountid,
    c.name as adjustedregisteraccountcreditorname,
    ci.accountnumber as adjustedregisteraccountnumber,
    null as achmonth,
    null as achyear,
    null as feemonth,
    null as feeyear,
    case when bounced = 0 and voided = 0 then 0 else 1 end as bouncedorvoided,
    n.numnotes,
    pc.numphonecalls,
	@StmtPeriod AS [StmtPeriod]
from
    tblregisterpayment rp
	inner join tblregister r on rp.feeregisterid = r.registerid 
	left join tblClient tcl on r.ClientID = tcl.ClientID
	left join tblaccount a on r.accountid = a.accountid 
	left join tblcreditorinstance ci on a.originalcreditorinstanceid = ci.creditorinstanceid 
	left join tblcreditor c on ci.creditorid = c.creditorid 
	left join tblentrytype ret on r.entrytypeid = ret.entrytypeid 
	left join
    (
	    select count(distinct noteid) as numnotes, relationid
		from tblnoterelation
		where relationtypeid = 5
		group by relationid
    )
    as n on rp.registerpaymentid = n.relationid left join
    (
		select count(distinct phonecallid) as numphonecalls, relationid
		from tblphonecallrelation
		where relationtypeid = 5
		group by relationid
    )
	as pc on rp.registerpaymentid = pc.relationid 
	where r.ClientID = @clientid
	and (rp.Bounced = 0 
	and rp.Voided = 0)
	
	order by Date, RegisterFirst, ID

	insert into tblStatementResults
	(
		ClientID,
		AccountNumber,
		RegisterFirst,
		registerID,
		TransactionDate,
		CheckNo,
		EntryTypeID,
		EntryTypeName,
		OrigionalAmt,
		Amount,
		SDABalance,
		PFOBalance,
		[description],
		AccountID,
		CreditorName,
		CreditorAcctNo,
		CurrentAmount,
		AdjustRegisterID,
		AdjTransactionDate,
		AdjRegAmount,
		AdjRegOrigAmount,
		AdjRegEntryTypeID,
		AdjRegAcctID,
		AdjRegAcctCreditorName,
		AdjRegAcctAcctNo,
		ACHMonth,
		ACHYear,
		FeeMonth,
		FeeYear,
		BounceOrVoid,
		NumNotes,
		NumPhoneCalls,
		StmtPeriod
	)
	select * from #tempresults

drop table #tempresults


GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

