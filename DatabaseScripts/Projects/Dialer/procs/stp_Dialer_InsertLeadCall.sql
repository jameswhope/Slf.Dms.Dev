IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_InsertLeadCall')
	BEGIN
		DROP  Procedure  stp_Dialer_InsertLeadCall
	END

GO

CREATE Procedure stp_Dialer_InsertLeadCall
@LeadApplicantId int,
@PhoneNumber varchar(20),
@QueueId int = 3,
@UserId int,
@Autodial bit = 1,
@CallId int = null
AS
Begin

Declare @CallIdKey varchar(20) 
Select @CallIdKey = Convert(varchar(20), @CallId)

Insert Into tblLeadDialerCall(LeadApplicantId, PhoneNumber, Created, CreatedBy, QueueId, AutoDial, CallId, OutboundCallKey)
Values(@LeadApplicantId, @PhoneNumber, GetDate(), @UserId, @QueueId, @AutoDial, @CallId, @CallIdKey)

Select Scope_identity()

End
