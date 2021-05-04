IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getTotalsByFirm')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getTotalsByFirm
	END

GO

CREATE Procedure stp_settlementimport_reports_getTotalsByFirm
	(
		@year int,
		@month int 
	)
AS
BEGIN
	declare @tblR table(rOrder int,Firm varchar(100), Submitted int, SubmittedPct float)
	declare @tot float
	select @tot = count(*) from tblSettlementTrackerImports where year(getdate()) = year(date) and @month = month(date)

	insert into @tblR 
	select 
		rorder = 0
		,[Firm] = LawFirm
		, [Submitted] = Count(*)
		, [SubmittedPct] = count(*)/ISNULL(NULLIF(convert(float,@tot),0),1)
	from 
		tblSettlementTrackerImports
	where 
		@year = year(date)
		and @month = month(date)
	group by LawFirm

	insert into @tblR 
	select 
	rorder = 1
	,[Firm] = 'TOTAL'
	, [Submitted] = sum(submitted)
	, [SubmittedPct] = cast(sum(submitted) as float)/ISNULL(NULLIF(convert(float,@tot),0),1)
	FROM @tblR

	select Firm, [Submitted]=isnull(Submitted,0), [SubmittedPct]=isnull(SubmittedPct,0)
	from @tblR where firm <> ''	order by rorder

END




GRANT EXEC ON stp_settlementimport_reports_getTotalsByFirm TO PUBLIC

