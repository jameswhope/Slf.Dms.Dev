IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetNextEliteLeadToCall')
	BEGIN
		DROP  Procedure stp_Dialer_GetNextEliteLeadToCall
	END
GO

CREATE Procedure stp_Dialer_GetNextEliteLeadToCall
AS
Begin

Declare @TotalMaxAttempt int
Declare @MaxAttemptDay int
Declare @CallStartDate Datetime

Select @TotalMaxAttempt = MaxAttempts, @MaxAttemptDay = MaxAttemptsPerDay, @CallStartDate =  CallStartDate  From tblDialerWorkGroupQueue
Where QueueName = 'CID Elite Dialer'


select top 1  l.leadapplicantid, 
callorder = 0,
leadphone, homephone, cellphone, l.statusid, l.created, l.stateid
from tblleadapplicant l
where 
--new, left message, no answer, recycled
(
	(l.statusid in (13, 15, 16, 17)
	and (@TotalMaxAttempt = 0 or 
	(Select Count(d.callmadeid) from tblleaddialercall d 
	 where d.outboundcallkey is not null
	 and d.LeadApplicantId = l.leadapplicantId
	 and d.created >= isnull(l.DialerLastRecycled, '1900-01-01')
	 ) < @TotalMaxAttempt)
	and (@MaxAttemptDay = 0 or 
	(Select Count(d.callmadeid) from tblleaddialercall d 
	 where d.outboundcallkey is not null and convert(varchar(10),d.created,101) = convert(varchar(10),getdate(),101)
	and d.LeadApplicantId = l.leadapplicantId
	and d.created >= isnull(l.DialerLastRecycled, '1900-01-01')
	) < @MaxAttemptDay)
	and (l.created > isnull(@CallStartDate, '2010-08-31') or isnull(l.DialerLastRecycled, '1900-01-01') > isnull(@CallStartDate, '2010-08-31'))
	)
)
and (l.dialerretryafter is null or l.dialerretryafter < getdate())
and ((l.leadphone <> '(   )    -    ' and isnull(l.leadphone, '') <> '')
or (l.homephone <> '(   )    -    ' and isnull(l.homephone, '') <> '')
or (l.cellphone <> '(   )    -    ' and isnull(l.cellphone, '') <> ''))
and (l.productid  in (144, 160, 161, 162))
-- and not pending appointment
and not exists (select a.appointmentId from tblleadcallappointment a where a.leadapplicantId = l.leadapplicantid and a.appointmentstatusid in (0,4) and datediff(n, getdate(), AppointmentDate) > -60)  
order by 2 asc, l.created desc
End

GO
