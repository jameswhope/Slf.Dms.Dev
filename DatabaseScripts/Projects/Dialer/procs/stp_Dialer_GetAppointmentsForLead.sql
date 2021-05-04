IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetAppointmentsForLead')
	BEGIN
		DROP  Procedure  stp_Dialer_GetAppointmentsForLead
	END

GO

CREATE Procedure stp_Dialer_GetAppointmentsForLead
@LeadApplicantId int
AS
Select 
case a.AppointmentStatusId when 0 then 0 else 1 end,
a.AppointmentId, 
a.AppointmentDate, 
a.AppointmentStatusId, 
s.StatusName
from tblleadcallappointment a
inner join tblleadappointmentstatus s on s.AppointmentStatusId = a.AppointmentStatusId
where a.LeadApplicantId = @LeadApplicantId
order by 1, a.AppointmentDate Desc

GO



