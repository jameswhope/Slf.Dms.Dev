/****** Object:  StoredProcedure [dbo].[stp_GetTransactionsNoPayments]    Script Date: 11/19/2007 15:27:19 ******/
DROP PROCEDURE [dbo].[stp_GetTransactionsNoPayments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetTransactionsNoPayments]
	(
		@returntop varchar (255) = '',
		@where varchar (8000) = '',
		@orderby varchar (8000) = ''
	)

as

exec
(
	'select
		' + @returntop + '
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
		aret.name as adjustedregisterentrytypename,
		r.achmonth,
		r.achyear,
		r.feemonth,
		r.feeyear,
		case when r.bounce is null and r.void is null then 0 else 1 end as bouncedorvoided,
		n.numnotes,
		pc.numphonecalls
	from
		tblregister r inner join
		tblentrytype et on r.entrytypeid = et.entrytypeid left join
		tblaccount a on r.accountid = a.accountid left join
		tblcreditorinstance ci on a.currentcreditorinstanceid = ci.creditorinstanceid left join
		tblcreditor c on ci.creditorid = c.creditorid left join
		tblregister ar on r.adjustedregisterid = ar.registerid left join
		tblentrytype aret on ar.entrytypeid = aret.entrytypeid left join
		(
			select
				count(distinct noteid) as numnotes,
				relationid
			from
				tblnoterelation
			where
				relationtypeid = 4
			group by
				relationid
		)
		as n on r.registerid = n.relationid left join
		(
			select
				count(distinct phonecallid) as numphonecalls,
				relationid
			from
				tblphonecallrelation
			where
				relationtypeid = 4
			group by
				relationid
		)
		as pc on r.registerid = pc.relationid '
	+ @where + ' '
	+ @orderby
)
GO
