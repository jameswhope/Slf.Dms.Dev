IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_UpdateCallBack')
	BEGIN
		DROP  Procedure  stp_Vici_UpdateCallBack
	END

GO

CREATE Procedure stp_Vici_UpdateCallBack
@LeadId int,
@SourceId varchar(50),
@CallBackDate datetime
AS
Begin
/*
	if @SourceId = 'CID'
	begin
		Return
	end
	if @SourceId = 'Clients'
	begin
		Update tblclient Set dialerresumeafter = Case When @CallBackDate > dialerresumeafter then @CallBackDate else dialerresumeafter End where clientid = @LeadId
	end
	if @SourceId = 'Matters'
	begin
		Update tblmatter Set dialerretryafter  = Case When @CallBackDate > DialerRetryAfter then @CallBackDate else DialerRetryAfter End where matterid = @LeadId
		
		Update tblclient Set dialerresumeafter = Case When @CallBackDate > dialerresumeafter then @CallBackDate else dialerresumeafter End
		where clientid in (select clientid from tblmatter where matterid = @LeadId) 
	end
*/

Return
End

GO

 

