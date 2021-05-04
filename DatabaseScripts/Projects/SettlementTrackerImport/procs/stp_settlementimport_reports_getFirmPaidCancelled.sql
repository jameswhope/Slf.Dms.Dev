IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getFirmPaidCancelled')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getFirmPaidCancelled
	END

GO

CREATE Procedure stp_settlementimport_reports_getFirmPaidCancelled
	(
		@year int,
		@month int
	)
AS
BEGIN
	declare @tblR table(rOrder int,LawFirm varchar(100),paid int,PctPaid float,Cancelled int,PctCancelled float,totunits int)
	declare @totalAmt money
	select @totalAmt = sum(settlementamt) from tblSettlementTrackerImports where year(canceldate) = year(getdate()) and month(canceldate) = @month 

	insert into @tblR 
	select 
		rorder = 0
		,[LawFirm] 
		, [Paid] =  sum(case when year(paid) = @year and month(paid) = @month  then 1 else 0 end)
		, [PctPaid] = cast(sum(case when year(paid) = @year and month(paid) = @month then 1 else 0 end) as float)/isnull(nullif(cast(sum(case when year(date) = @year and month(date) = @month then 1 else 0 end) as float),0),1)
		, [Cancelled] = sum(case when year(canceldate) = @year and month(canceldate) = @month then 1 else 0 end)
		, [PctCancelled] = cast(sum(case when year(canceldate) = @year and month(canceldate) = @month then 1 else 0 end) as float)/cast(count(*) as float)
		, [totunits] = sum(case when year(date) = @year and month(date) = @month then 1 else 0 end) 
	FROM tblSettlementTrackerImports
	--where canceldate is null or expired is null
	group by LawFirm
		
	insert into @tblR 
	select 
		rOrder = 1
		,[LawFirm] = 'TOTAL'
		, [Paid] =  sum(paid)
		, [PctPaid] = cast(sum(paid) as float)/cast(sum(totunits) as float)
		, [Cancelled] = sum(cancelled)
		, [PctCancelled] = cast(sum(cancelled) as float)/cast(sum(totunits) as float)
		,[totunits]=sum(totunits)
	FROM @tblR


	select [LawFirm]=isnull(lawfirm,0), [Paid]=isnull(paid,0), [PctPaid]=isnull(PctPaid,0), 
	[Cancelled]=isnull(Cancelled,0), [PctCancelled]=isnull(PctCancelled,0)
	from @tblR	order by rorder
END

GRANT EXEC ON stp_settlementimport_reports_getFirmPaidCancelled TO PUBLIC


