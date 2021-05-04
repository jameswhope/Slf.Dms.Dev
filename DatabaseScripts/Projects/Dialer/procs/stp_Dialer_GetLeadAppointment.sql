IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetLeadAppointment')
	BEGIN
		DROP  Procedure  stp_Dialer_GetLeadAppointment
	END

GO

CREATE Procedure stp_Dialer_GetLeadAppointment
@AppointmentId int
AS
select a.*, s.StatusName, 
[createdbyuser] = isnull(u.firstname, '') + ' ' + isnull(u.lastname,''),
[lastmodifiedbyuser] = isnull(u1.firstname, '') + ' ' +isnull(u1.lastname,''),
[calledbyuser] = isnull(u2.firstname, '') + ' ' + isnull(u2.lastname,'') 
from tblLeadCallAppointment a
inner join tbluser u on u.userid = a.createdby
inner join tbluser u1 on u1.userid = a.lastmodifiedby
left join tbluser u2 on u2.userid = a.calledby
inner join tblLeadAppointmentStatus s on s.AppointmentStatusId = a.AppointmentStatusId
where a.appointmentid = @AppointmentId

GO

 
