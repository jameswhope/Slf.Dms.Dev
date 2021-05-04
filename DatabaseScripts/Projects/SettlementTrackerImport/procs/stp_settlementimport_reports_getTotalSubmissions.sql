IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getTotalSubmissions')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getTotalSubmissions
	END

GO

CREATE Procedure stp_settlementimport_reports_getTotalSubmissions
	(
		@year int,
		@month int
	)
AS
BEGIN
	select 
		[Amount] = '$' + convert(varchar, CONVERT(money, isnull(sum(settlementfees) ,0.00)),1)
		, [Total] = Count(*)
	from 
		tblSettlementTrackerImports
	where 
		@year = year(date)
		and @month = month(date)
END

GRANT EXEC ON stp_settlementimport_reports_getTotalSubmissions TO PUBLIC


