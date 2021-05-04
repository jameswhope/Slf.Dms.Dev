
alter procedure stp_ActiveClientsByMonth
(
	@from datetime,
	@to datetime
)
as
begin

declare @date datetime
declare @active table (mth int, yr int, active int)

-- get clients and their termination date (if any)
select c.clientid, c.created, termdate = (select top(1) rm.created from tblroadmap rm where clientstatusid in (15,16,17,18) and rm.clientid = c.clientid order by roadmapid desc)
into #clients
from tblclient c
where c.accountnumber is not null

while @from < @to begin
	set @date = dateadd(month,1,@from)

	-- count active cliens for the current month
	insert @active
	select month(@from), year(@from), count(*)
	from #clients
	where (termdate is null or termdate >= @date) -- if terminated, must be after the current month
	and (created < @date) 

	set @from = dateadd(month,1,@from)
end

select *
from @active
order by yr, mth

drop table #clients

end
go 