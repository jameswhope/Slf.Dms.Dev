IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getYTD')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getYTD
	END

GO

create procedure [dbo].[stp_settlementimport_reports_getYTD]
as
BEGIN
	declare @start datetime
	declare @end datetime

	set @start = DATEADD(yy, DATEDIFF(yy,0,getdate()), 0);
	set @end = DATEADD(yy, 1,@start);

	with mycte as (
	select  [DateValue] = @start
	 union all 
	select DateValue + 1 
	from    mycte    
	where   DateValue + 1 < @end)
	select  
		[SettMonth] = Month([DateValue])
		, [Fees] = isnull(convert(money,sum(settlementfees)),0)
		, [Units] = count(settlementfees)
	from mycte left join
	tblSettlementTrackerImports sti on sti.[due] = mycte.DateValue
	where canceldate is null --and [date] >= @start
	group by Month([DateValue])
	order by Month([DateValue])
	OPTION  (MAXRECURSION 0)
END


GRANT EXEC ON stp_settlementimport_reports_getYTD TO PUBLIC


