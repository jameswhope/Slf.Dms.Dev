IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_SyncLeadStatus')
	BEGIN
		DROP  Procedure  stp_Vici_SyncLeadStatus
	END

GO

CREATE Procedure stp_Vici_SyncLeadStatus
@LeadId int,
@SourceId varchar(50),
@DispoCode varchar(20),
@DispoDate datetime,
@CallCount int = NULL,
@UserName varchar(20),
@Minutes int = 60
AS
Begin

	If @SourceId = 'CID' 
	Begin
		exec stp_Vici_SyncLeadStatus_CID @LeadId, @DispoCode, @DispoDate, @CallCount, @UserName, @Minutes
		Return
	End
	
	If @SourceId = 'MATTERS' 
	Begin
		exec stp_Vici_SyncLeadStatus_MATTERS @LeadId, @DispoCode, @DispoDate, @CallCount, @UserName, @Minutes
		Return
	End
	
	If @SourceId = 'CLIENTS'
	Begin
		Update tblclient Set dialerresumeafter = Case When (dialerresumeafter is null or DateAdd(n, @Minutes, GetDate()) > dialerresumeafter) then DateAdd(n, @Minutes, GetDate()) else dialerresumeafter end where clientid = @LeadId
		Return
	End
End
