IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_LeadUpdateAppointmentStatus4Result')
	BEGIN
		DROP  Procedure  stp_Dialer_LeadUpdateAppointmentStatus4Result
	END

GO

CREATE Procedure stp_Dialer_LeadUpdateAppointmentStatus4Result
@CallMadeId int,
@ResultId int,
@UserId int
AS
Begin
	Declare @AppointmentStatusId int
	Select @AppointmentStatusId = NULL
	Select @AppointmentStatusId = AppointmentStatusId from tblLeadDialerCallResultType where LeadResultTypeId = @ResultId
	
	if not @AppointmentStatusId is null
	Begin
		Update tblLeadCallAppointment Set
		CallResultId = @ResultId,
		AppointmentStatusId = @AppointmentStatusId,
		LastModified = GetDate(),
		LastModifiedBy = @UserId
		Where CallMadeId = @CallMadeId
	End 
End

GO

 

