IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getPaidFeesTotal')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getPaidFeesTotal
	END

GO

create procedure stp_settlementimport_reports_getPaidFeesTotal
as
BEGIN
	select 
		[Team] = Team
		, [Fees] = convert(money,sum(settlementfees))
	from tblSettlementTrackerImports
	where canceldate is null
	group by team 
	order by team
END


GRANT EXEC ON stp_settlementimport_reports_getPaidFeesTotal TO PUBLIC


