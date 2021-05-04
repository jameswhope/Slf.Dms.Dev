IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getDaysTurnAround')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getDaysTurnAround
	END

GO

CREATE Procedure stp_settlementimport_reports_getDaysTurnAround
(
	@year int,
	@month int
)
AS
BEGIN

declare @tblTurn table (team varchar(100), negotiator varchar(200),StartDate datetime, EndDate datetime, [TurnAroundDays] int)

insert into @tblTurn
select team,negotiator,date, paid, [TurnAroundDays]=datediff(d,date,paid) 
from tblsettlementtrackerimports
where paid is not null and [date] is not null and expired is null 
and year(paid) = @year
and month(paid) = @month
and paid > '1900-01-01 00:00:00.000'
order by team,negotiator

select team
, [AvgDaysTurnAround]=sum(turnarounddays)/count(*)
from @tblTurn
group by team
END


GRANT EXEC ON stp_settlementimport_reports_getDaysTurnAround TO PUBLIC


