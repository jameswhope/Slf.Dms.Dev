IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetTransactionByType_FeeAdjustments')
	BEGIN
		DROP  Procedure  stp_GetTransactionByType_FeeAdjustments
	END

GO

CREATE procedure [dbo].[stp_GetTransactionByType_FeeAdjustments]
	(
		@clientId int
	)

as

select
	r.*,
	et.[name] as entrytypename,
	r.adjustedregisterid,
	ar.transactiondate as adjustedregistertransactiondate,
	ar.amount as adjustedregisteramount,
	ar.originalamount as adjustedregisteroriginalamount,
	ar.entrytypeid as adjustedregisterentrytypeid,
	aret.name as adjustedregisterentrytypename,
	tar.DisplayName[AdjustedReason]
from
	tblregister r INNER JOIN
	tblentrytype et ON r.entrytypeid = et.entrytypeid inner join
	tblregister ar on r.adjustedregisterid = ar.registerid inner join
	tblentrytype aret on ar.entrytypeid = aret.entrytypeid LEFT OUTER JOIN
    tblTranAdjustedReason AS tar ON r.AdjustedReasonID = tar.TranAdjustedReasonID
where
	r.clientid = @clientid and
	aret.fee = 1
order by
	r.transactiondate, r.registerid


GRANT EXEC ON stp_GetTransactionByType_FeeAdjustments TO PUBLIC



