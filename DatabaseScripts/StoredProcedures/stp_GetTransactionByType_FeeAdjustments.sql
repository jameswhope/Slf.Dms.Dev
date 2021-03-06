/****** Object:  StoredProcedure [dbo].[stp_GetTransactionByType_FeeAdjustments]    Script Date: 11/19/2007 15:27:18 ******/
DROP PROCEDURE [dbo].[stp_GetTransactionByType_FeeAdjustments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
    tblTranAdjustedReason AS tar ON tblRegister.AdjustedReasonID = tar.TranAdjustedReasonID
where
	r.clientid = @clientid and
	aret.fee = 1
order by
	r.transactiondate, r.registerid
GO
