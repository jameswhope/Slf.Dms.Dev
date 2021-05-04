IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getExpired')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getExpired
	END

GO

create procedure stp_settlementimport_reports_getExpired
(
@year int,
@month int
)
as
BEGIN
	--declare @month int
	--set @month = 9

	select 
		[Amount] = '$' +  convert(varchar, sum(case when year(expired) = @year and month(expired) = @month and paid is null then settlementfees else 0 end),1)
	, [Total] = sum(case when year(expired) = @year and month(expired) = @month and paid is null then 1 else 0 end)
	from tblSettlementTrackerImports
END


GRANT EXEC ON stp_settlementimport_reports_getExpired TO PUBLIC


 