IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetGoals')
	DROP  Procedure  stp_GetGoals
GO

create procedure stp_GetGoals
(
	@startdate datetime
)
as
begin


select g.date, cast(day(g.date) as varchar(2)) [day], g.goal, count(c.clientid) [submitted], 
	case when g.date < getdate() and g.goal > 0 then count(c.clientid) - g.goal else 0 end [diff]
from tblleadgoals g
left join tblclient c on convert(varchar(10),c.created,101) = convert(varchar(10),g.date,101)
left join vw_leadapplicant_client v on v.clientid = c.clientid
left join tblleadapplicant l on l.leadapplicantid = v.leadapplicantid
where month(g.date) = month(@startdate)
and year(g.date) = year(@startdate)
group by g.date, g.goal
order by g.date


end
go 