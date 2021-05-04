IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_ExpireLeadAppointments')
	BEGIN
		DROP  Procedure  stp_Dialer_ExpireLeadAppointments
	END

GO

CREATE Procedure stp_Dialer_ExpireLeadAppointments 
as
 update tblleadcallappointment set
appointmentstatusid = 5 
where   appointmentstatusid in (0,4) 
and datediff(n, getdate(), AppointmentDate) < -60
