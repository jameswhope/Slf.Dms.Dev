IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getExpiredCancelledByTeam')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getExpiredCancelledByTeam
	END

GO

CREATE Procedure stp_settlementimport_reports_getExpiredCancelledByTeam
	(
		@year int,
		@month int 
	)
AS
BEGIN
	declare @tblR table(rOrder int,team varchar(100), Expired int, cancelled int)

	insert into @tblR 
	select 
		rorder = 0
		,Team
		, [Expired] = sum(case when year(expired) = @year and month(expired) = @month and paid is null then 1 else 0 end)
		, [Cancelled] = sum(case when year(canceldate) = @year and month(canceldate) = @month  then 1 else 0 end)
	from 
		tblSettlementTrackerImports
	group by Team 


	insert into @tblR 
	select 
		rorder = 1
		,Team = 'TOTAL'
		, [Expired] = sum(expired)
		, [Cancelled] = sum(cancelled)
	FROM @tblR


	select Team, [Expired]=isnull(Expired,0), [Cancelled]=isnull(Cancelled,0)
	from @tblR where team <> ''	order by rorder
END


GRANT EXEC ON stp_settlementimport_reports_getExpiredCancelledByTeam TO PUBLIC


