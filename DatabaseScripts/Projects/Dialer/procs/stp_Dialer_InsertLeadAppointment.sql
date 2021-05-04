IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_InsertLeadAppointment')
	BEGIN
		DROP  Procedure  stp_Dialer_InsertLeadAppointment
	END

GO

CREATE Procedure stp_Dialer_InsertLeadAppointment
@LeadApplicantId int,
@PhoneNumber varchar(20),
@AppointmentDate datetime,
@TimeZoneId int,
@AppointmentNote varchar(1000) = Null,
@AppointmentStatusId int,
@UserId int
AS
BEGIN

	Insert Into tblLeadCallAppointment(LeadApplicantId, PhoneNumber, AppointmentDate, TimeZoneId, Created, CreatedBy, LastModified, LastModifiedBy, AppointmentNote, AppointmentStatusId)
	Values (@LeadApplicantId, @PhoneNumber, @AppointmentDate, @TimeZoneId, GetDate(), @UserId,  GetDate(), @UserId, @AppointmentNote, @AppointmentStatusId)

	Select scope_identity()
	
END

GO


