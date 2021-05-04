IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_InsertCallLog_MATTERS')
	BEGIN
		DROP  Procedure  stp_Vici_InsertCallLog_MATTERS
	END

GO

CREATE Procedure stp_Vici_InsertCallLog_MATTERS
@matterid int, 
@callid int,
@calldate datetime
AS
BEGIN
declare @clientid int, @reasonid int
 
select @clientid = m.clientid, @reasonId = (Select mt.DialerCallReasonTypeId from tblmattertype mt where mt.mattertypeid = m.mattertypeid) from tblmatter m where m.matterid = @matterid

exec stp_Dialer_InsertClientLog @clientid, @reasonid, @calldate
exec stp_Vici_InsertMatterCallSummary @matterid, @reasonid, @calldate
exec stp_Dialer_InsertMatterLog @callid, @matterid, @reasonid

update tblmatter set
dialercount = dialercount + 1
where matterid = @matterid
	
END
GO

