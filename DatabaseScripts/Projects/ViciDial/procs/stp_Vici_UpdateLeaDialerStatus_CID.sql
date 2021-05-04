IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_UpdateLeadDialerStatus_CID')
	BEGIN
		DROP  Procedure  stp_Vici_UpdateLeadDialerStatus_CID
	END

GO

CREATE Procedure stp_Vici_UpdateLeadDialerStatus_CID
@LeadId int,
@DialerStatusId int
AS
Update tblLeadApplicant Set DialerStatusID = @DialerStatusId Where LeadApplicantId = @LeadId

GO
