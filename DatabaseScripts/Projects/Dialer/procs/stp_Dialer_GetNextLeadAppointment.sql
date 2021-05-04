--stp_Dialer_GetNextLeadAppointment

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetNextLeadAppointment')
	BEGIN
		DROP  Procedure  stp_Dialer_GetNextLeadAppointment
	END

GO

CREATE Procedure stp_Dialer_GetNextLeadAppointment
AS
Begin

select top 1 l.leadapplicantid, a.appointmentId, leadphone = a.phonenumber, homephone=null, cellphone=null, l.statusid, l.created, l.stateid  
from tblleadcallappointment a
inner join tblleadapplicant l on l.leadapplicantid = a.leadapplicantid
where appointmentstatusid = 0 
and getdate() between dateadd(n, -2, appointmentdate) and dateadd(n, 20, appointmentdate) 
and l.statusid not in (1,4,5,8,9,14,19)
order by appointmentdate asc

End
 
 