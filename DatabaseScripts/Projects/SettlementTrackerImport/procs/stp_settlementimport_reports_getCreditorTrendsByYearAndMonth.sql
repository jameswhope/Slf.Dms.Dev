IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getCreditorTrendsByYearAndMonth')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getCreditorTrendsByYearAndMonth
	END

GO

CREATE Procedure stp_settlementimport_reports_getCreditorTrendsByYearAndMonth
	(
		@year int,
		@month int,
		@top varchar(20) = null,
		@team varchar(50) = null
	)

AS
BEGIN
if @team is null
	BEGIN
		if @top is null
			BEGIN
				set @top = ''
			END
	
		exec('
		declare @tbltrends table (CreditorName	varchar(max),TotalUnits int,TotalSettlementAmt float,TotalSettlementFee float,AvgSettlementPct float)

		insert into @tbltrends 
		SELECT 
		cur.name[CreditorName]
		,count(*)[TotalUnits]
		,sum(sett.settlementamount)[TotalSettlementAmt]
		,sum(sett.settlementfee)[TotalSettlementFee]
		,sum(sett.settlementamount)/sum(ISNULL(NULLIF(convert(float,a.currentamount),0),1))[AvgSettlementPct]
		FROM tblSettlements AS sett with(readpast)
		inner join tblaccount a with(readpast) on a.accountid = sett.creditoraccountid
		inner join tblcreditorinstance ci with(readpast) on a.currentcreditorinstanceid = ci.creditorinstanceid
		inner join tblcreditor cur with(readpast) on cur.creditorid = ci.creditorid
		inner join tblsettlementtrackerimports sti with(readpast) on sti.settlementid = sett.settlementid
		WHERE   sett.status = ''a'' and active = 1 and year(sti.paid) = ' + @year + ' and month(sti.paid) = ' + @month + '
		and expired is null and canceldate is null and paid is not null
		group by cur.name
		option (fast 100)

		select ' + @top + ' * from @tbltrends order by totalunits desc,[CreditorName]
		')
	END
ELSE
	BEGIN
	SELECT cur.name[CreditorName],team,negotiator,count(*)[TotalUnits],sum(sett.settlementamount)[TotalSettlementAmt],sum(sett.settlementfee)[TotalSettlementFee]
	,sum(sett.settlementamount)/sum(ISNULL(NULLIF(convert(float,a.currentamount),0),1))[AvgSettlementPct] 
	into #tmpTrends
	FROM tblSettlements AS sett with(readpast) 
	inner join tblaccount a with(readpast) on a.accountid = sett.creditoraccountid
	inner join tblcreditorinstance ci with(readpast) on a.currentcreditorinstanceid = ci.creditorinstanceid
	inner join tblcreditor cur with(readpast) on cur.creditorid = ci.creditorid
	inner join tblsettlementtrackerimports sti with(readpast) on sti.settlementid = sett.settlementid
	WHERE   sett.status = 'a' and active = 1 and year(sti.paid) = @year and month(sti.paid) = @month 
	and expired is null and canceldate is null and paid is not null
	group by cur.name,team,negotiator
	option (fast 100)

	DECLARE @casecolumns VARCHAR(max)

	SELECT @casecolumns = COALESCE(@casecolumns + ',sum(case when negotiator = ' + char(39) + [negotiator] + char(39) + ' then TotalUnits else 0 end)[' + cast([negotiator] as varchar) + ']',
	',sum(case when negotiator = ' + char(39) + [negotiator] + char(39) + ' then TotalUnits else 0 end)[' + cast([negotiator] as varchar) + ']')
	FROM #tmpTrends
	where team = @team --and [CreditorName] = 'Chase'
	GROUP BY [negotiator]

	exec('select * from (
	select creditorname[CreditorName] ' + @casecolumns + ', sum(totalunits)[TotalUnits]
	, sum(TotalSettlementAmt)[TotalSettlementAmt] 
	, avg(AvgSettlementPct)[AvgSettlementPct] 
	, sum(TotalSettlementFee)[TotalSettlementFee] 
	from #tmpTrends 
	where team = '''  + @team + '''
	group by creditorname
	) as tdata 
	order by totalunits desc,CreditorName
	')

	drop table #tmpTrends
	END	
END


GRANT EXEC ON stp_settlementimport_reports_getCreditorTrendsByYearAndMonth TO PUBLIC

GO


