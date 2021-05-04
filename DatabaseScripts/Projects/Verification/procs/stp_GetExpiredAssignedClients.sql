IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetExpiredAssignedClients')
	BEGIN
		DROP  Procedure  stp_GetExpiredAssignedClients
	END
GO

create procedure stp_GetExpiredAssignedClients
as
begin


	select clientid, accountnumber, leadapplicantid, assignedunderwriter
	from (
		select c.clientid, c.accountnumber, l.leadapplicantid, isnull(c.AssignedUnderwriter,0)[AssignedUnderwriter],
			case 
				when datepart(weekday,s.statuscreated) = 6 then dateadd(d,2,s.statuscreated) -- Fri
				when datepart(weekday,s.statuscreated) = 7 then dateadd(d,1,s.statuscreated) -- Sat
				else s.statuscreated
			end [statuscreated]
		from tblclient c
		join tblimportedclient i on i.importid = c.serviceimportid
		join tblleadapplicant l on l.leadapplicantid = i.externalclientid
		join vw_enrollment_CurrentStatusCreated s on s.leadapplicantid = l.leadapplicantid
		left join vw_enrollment_ver_complete ver on ver.leadapplicantid = l.leadapplicantid
		where c.currentclientstatusid in (7,23,24) -- Recieved LSA, Returned to CID, Return to Compliance
		and l.statusid in (10,19) -- In Process, Return to Compliance
		and ver.completed is null
	) d
	where datediff(hour,statuscreated,getdate()) > 24
	and accountnumber not in ('6089140','6089036') -- temp, these clients are supposed to be Canceling


end
go 