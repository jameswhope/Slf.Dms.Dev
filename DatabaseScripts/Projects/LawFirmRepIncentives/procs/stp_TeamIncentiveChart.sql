if exists (select 1 from sysobjects where name = 'stp_TeamIncentiveChart') 
	drop procedure stp_TeamIncentiveChart
go

create procedure stp_TeamIncentiveChart
as
begin

declare @initial varchar(500)

select @initial = coalesce(@initial + ', ', '') + cast(initialpymt as varchar(10)) + ' [' + cast(clientsmin as varchar(10)) + '-' + cast(clientsmax as varchar(10)) + ']'
from tblincentivechart c 
join tblincentivecharts s on s.incentivechartid = c.incentivechartid and s.validto is null and s.supervisor = 1 
order by clientsmin

exec('select ''Initial'' [Leads], ' + @initial) 


end
go