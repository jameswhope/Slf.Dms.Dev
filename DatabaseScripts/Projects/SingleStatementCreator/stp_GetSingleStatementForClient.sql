IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSingleStatementForClient')
	BEGIN
		DROP  Procedure  stp_GetSingleStatementForClient
	END

GO
/****** Object:  StoredProcedure [dbo].[stp_GetSingleStatementForClient]    Script Date: 10/29/2009 16:47:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[stp_GetSingleStatementForClient]

@clientid int,
@From smalldatetime,
@To smalldatetime

as

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

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
    pc.numphonecalls

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
	and r.transactiondate between @From and @To
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
    pc.numphonecalls
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
	and rp.paymentdate between @From and @To
	
	order by Date, RegisterFirst, ID

	insert into tblSingleStatementResults
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
		description,
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
		NumPhoneCalls
	)
	select * from #tempresults

drop table #tempresults
GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

