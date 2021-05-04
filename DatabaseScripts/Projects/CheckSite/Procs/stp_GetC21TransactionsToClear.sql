 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetC21TransactionsToClear')
	BEGIN
		DROP  Procedure  stp_GetC21TransactionsToClear
	END

GO

CREATE Procedure stp_GetC21TransactionsToClear
AS
select t.transactionid, t.processeddate, r.registerid from tblregister r
inner join tblc21batchtransaction t on t.depositid = r.registerid and r.entrytypeid = 3
inner join tblclient c on c.clientid = r.clientid and c.trustid = 22
where r.clear is null
and t.state = 1 and t.status not in (1)
and (hold is not null and (hold <= getdate() or hold = cast('2050-12-31' as datetime)))
and t.transactionid <> 'csi_00000038927'

GO