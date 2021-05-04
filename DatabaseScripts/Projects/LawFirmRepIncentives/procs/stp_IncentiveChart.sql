if exists (select 1 from sysobjects where name = 'stp_IncentiveChart') 
	drop procedure stp_IncentiveChart
go

create procedure stp_IncentiveChart
(
	@repid int
)
as
begin

declare @initial varchar(500), @residual varchar(500), @residualold varchar(500)

if exists (select 1 from tblincentivechart c
			join tblincentivecharts s on s.incentivechartid = c.incentivechartid and s.validto is null and s.supervisor = 0 
			join tblIncentiveChartXref x on x.incentivechartid = s.incentivechartid and x.repid = @repid) begin

	select @initial = coalesce(@initial + ', ', '') + cast(initialpymt as varchar(10)) + ' [' + cast(clientsmin as varchar(10)) + '-' + cast(clientsmax as varchar(10)) + ']'
	from tblincentivechart c
	join tblincentivecharts s on s.incentivechartid = c.incentivechartid and s.validto is null and s.supervisor = 0 
	join tblIncentiveChartXref x on x.incentivechartid = s.incentivechartid and x.repid = @repid 
	order by clientsmin

	select @residual = coalesce(@residual + ', ', '') + cast(residual as varchar(10)) + ' [' + cast(clientsmin as varchar(10)) + '-' + cast(clientsmax as varchar(10)) + ']'
	from tblincentivechart c
	join tblincentivecharts s on s.incentivechartid = c.incentivechartid and s.validto is null and s.supervisor = 0 
	join tblIncentiveChartXref x on x.incentivechartid = s.incentivechartid and x.repid = @repid 
	order by clientsmin
	
	select @residualold = coalesce(@residualold + ', ', '') + cast(residualold as varchar(10)) + ' [' + cast(clientsmin as varchar(10)) + '-' + cast(clientsmax as varchar(10)) + ']'
	from tblincentivechart c
	join tblincentivecharts s on s.incentivechartid = c.incentivechartid and s.validto is null and s.supervisor = 0 
	join tblIncentiveChartXref x on x.incentivechartid = s.incentivechartid and x.repid = @repid 
	order by clientsmin

	exec('select ''Initial'' [Leads], ' + @initial + '
			union 
		select ''Residual'', ' + @residual + '
			union
		select ''Residual(2010)'', ' + @residualold) 
end
	
	
end
go