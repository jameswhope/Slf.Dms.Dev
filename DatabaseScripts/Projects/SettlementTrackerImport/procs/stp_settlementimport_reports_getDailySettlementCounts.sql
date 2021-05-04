IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getDailySettlementCounts')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getDailySettlementCounts
	END

GO

CREATE Procedure stp_settlementimport_reports_getDailySettlementCounts
(
	@year int,
	@month int
)
AS
BEGIN
	declare @tbldata table ([date] varchar(10), generated int, paid int)

	insert into @tbldata
	select 
		[date] =  convert(varchar(10), date, 101)
		, [Generated]= sum (case when year(date) = @year and month(date) = @month then 1 else 0 end)
		,paid= 0
		from tblsettlementtrackerimports
		where year(date) = @year and month(date) = @month
		group by [date]
		order by [date] desc

	insert into @tbldata
	select 
		[date] =  convert(varchar(10), paid, 101)
		, [Generated]= 0
		,paid= sum (case when year(paid) = @year and month(paid) = @month then 1 else 0 end)
		from tblsettlementtrackerimports
		where year(paid) = @year and month(paid) = @month
		group by paid
		order by paid desc

		insert into @tbldata
	select 'Total',sum(generated), sum(paid) from @tbldata


	select date, [Generated]=sum(generated), [Paid]=sum(paid) 
	from @tbldata
	group by date

END


GRANT EXEC ON stp_settlementimport_reports_getDailySettlementCounts TO PUBLIC

GO


