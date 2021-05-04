
if exists (select * from sysobjects where name = 'stp_GetWCFLog')
	drop procedure stp_GetWCFLog
go

create procedure stp_GetWCFLog
(
	@date datetime = null
)
as 
begin


if @date is null begin
	set @date = getdate()	
end	

select Process
from tblWCFLogs 
where Created >= convert(varchar(10),@date,101) 
	and Process is not null
group by Process
order by max(Created)

select 
	[Status],
	case 
		when [Status] = 'OK' then 'green'
		when [Status] = 'ERROR' then 'red'
		when [Status] = 'WARNING' then 'orange'
		else 'black'
	end Color,
	convert(varchar(30),Created,108) [Created], 
	Process, 
	[Message]
from tblWCFLogs 
where Created >= convert(varchar(10),@date,101) 
	and Process is not null
	and Show = 1
order by LogId


end 