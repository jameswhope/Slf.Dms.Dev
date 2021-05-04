IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getCancelled')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getCancelled
	END

GO

CREATE Procedure stp_settlementimport_reports_getCancelled
	(
		@year int,
		@month int
	)
AS
BEGIN
	declare @totalAmt money
	select @totalAmt = sum(settlementfees) from tblSettlementTrackerImports where year(canceldate) = year(getdate()) and month(canceldate) = @month 
	select 
		[Amount] = '$' + convert(varchar, sum(case when year(canceldate) = @year and month(canceldate) = @month and paid is null then settlementfees else 0 end),1)
		, [Total] = sum(case when year(canceldate) = @year and month(canceldate) = @month  then 1 else 0 end)
		, [Pct] = case when sum(case when year([date]) = @year and month([date]) = @month then 1 else 0 end) = 0 then 0
					else 
					sum(case when year(canceldate) = @year and month(canceldate) = @month  then 1 else 0 end)/cast(sum(case when year([date]) = @year and month([date]) = @month then 1 else 0 end) as float)end *100 
	from 
		tblSettlementTrackerImports
	
END


GRANT EXEC ON stp_settlementimport_reports_getCancelled TO PUBLIC


