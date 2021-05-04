IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_UpdateLeadAppointment')
	BEGIN
		DROP  Procedure  stp_Dialer_UpdateLeadAppointment
	END

GO

CREATE Procedure stp_Dialer_UpdateLeadAppointment
@AppointmentId int,
@PhoneNumber varchar(20) = null,
@AppointmentDate datetime = null,
@TimeZoneId int = null,
@AppointmentNote varchar(1000) = null,
@AppointmentStatusId int = null,
@CallIdKey varchar(20) = null,
@CalledBy int = null,
@CallDate datetime = null,
@CallResultId int = null,
@UserId int
AS
Begin

Update tblLeadCallAppointment Set
PhoneNumber = isnull(@PhoneNumber, PhoneNumber),
AppointmentDate =  isnull(@AppointmentDate, AppointmentDate),
TimeZoneId = isnull(@TimeZoneId, TimeZoneId),
AppointmentNote = isnull(@AppointmentNote, AppointmentNote),
AppointmentStatusId = isnull(@AppointmentStatusId, AppointmentStatusId),
CallIdKey = isnull(@CallIdKey, CallIdKey),
CalledBy = isnull(@CalledBy, CalledBy),
CallDate = isnull(@CallDate, CallDate),
CallResultId = isnull(@CallResultId, CallResultId),
LastModified = GetDate(),
LastModifiedBy = @UserId
Where AppointmentId = @AppointmentId

End

GO



