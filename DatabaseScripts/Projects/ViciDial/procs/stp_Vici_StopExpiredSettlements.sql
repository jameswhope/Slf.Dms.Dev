IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_StopExpiredSettlements')
	BEGIN
		DROP  Procedure  stp_Vici_StopExpiredSettlements
	END

GO

CREATE Procedure stp_Vici_StopExpiredSettlements
AS
Begin
	Declare @matterid int
	DECLARE setts_cursor CURSOR FOR
	select s.matterid from tblsettlementroadmap r
	join tblsettlements s  on s.settlementid = r.settlementid
	where r.matterstatuscodeid = 43 and r.created > '2014-07-01' 
	and s.matterid  not  in (select leadid from tblViciStopLeadRequestLog where sourceid='matters');

	OPEN setts_cursor

	FETCH NEXT FROM setts_cursor INTO @matterid

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Stop sett ' + convert(varchar,@matterid)
		exec stp_Vici_InsertStopLeadRequest @matterid, 'MATTERS', 'Settlement tblmatter expired'
		FETCH NEXT FROM setts_cursor INTO @matterid
	END

	CLOSE setts_cursor;
	DEALLOCATE setts_cursor;
End

GO
 
