IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_UpdateLeadDialerStatus')
	BEGIN
		DROP  Procedure  stp_Vici_UpdateLeadDialerStatus
	END

GO

CREATE Procedure stp_Vici_UpdateLeadDialerStatus
@LeadId int,
@SourceId varchar(50),
@DialerStatusId int
AS
Begin
	If @SourceId = 'CID' 
		Begin
			exec stp_Vici_UpdateLeadDialerStatus_CID @LeadId, @DialerStatusId
			Return
		End
		
	If @SourceId = 'CLIENTS'
		Begin
			Return
		End
		
	If @SourceId = 'MATTERS'
		Begin
			Update tblMatter Set DialerStatusID = @DialerStatusId Where MatterId = @LeadId
			Return
		End
End
GO



