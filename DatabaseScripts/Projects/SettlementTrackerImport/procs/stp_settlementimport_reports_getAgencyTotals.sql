IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getAgencyTotals')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getAgencyTotals
	END

GO

CREATE Procedure [dbo].[stp_settlementimport_reports_getAgencyTotals]
(
@year int,
@month int
)
as
BEGIN
	declare @tblR table(
		rOrder int
		,[AgencyName] varchar(150)
		,[TotalFees] money
		,[TotalBalance]  money
		,[TotalSettAmt] money
		,[TotalUnits] int
		,[TotalAvgPct] float
		,[PaidFees] money
		,[PaidBalance] money
		,[PaidSettAmt] money
		,[PaidUnits] int
		,[PaidAvgPct] float
		,[PctPaid] float
		,[PaidAvgFee] money
		)
	insert into @tblR 
	select 
		rOrder= 0
		,[AgencyName]= a.name 
		,[TotalFees] = sum(case when year(date) = @year and month(date) = @month then settlementfees else 0 end)
		,[TotalBalance] = sum(case when year(date) = @year and month(date) = @month then balance else 0 end)
		,[TotalSettAmt] = sum(case when year(date) = @year and month(date) = @month then settlementamt else 0 end)
		,[TotalUnits]= sum(case when year(date) = @year and month(date) = @month then 1 else 0 end)
		,[TotalAvgPct] = case when sum(case when year(date) = @year and month(date) = @month then balance else 0 end)=0 then 0 else sum(case when year(date) = @year and month(date) = @month then settlementamt else 0 end)/sum(case when year(date) = @year and month(date) = @month then balance else 0 end)end
		,[PaidFees] = sum(case when year(paid) = @year and month(paid) = @month and canceldate is null and expired is null then settlementfees else 0 end)
		,[PaidBalance]= sum(case when year(paid) = @year and month(paid) = @month and canceldate is null and expired is null then balance else 0 end)
		,[PaidSettAmt]= sum(case when year(paid) = @year and month(paid) = @month and canceldate is null and expired is null  then settlementamt else 0 end)
		,[PaidUnits] = sum(case when year(paid) = @year and month(paid) = @month and canceldate is null and expired is null  then 1 else 0 end)
		,[PaidAvgPct]=case when sum(case when year(paid) = @year and month(paid) = @month  and canceldate is null and expired is null  then balance else 0 end) = 0 then 0 else sum(case when year(paid) = @year and month(paid) = @month  and canceldate is null and expired is null then settlementamt else 0 end)/sum(case when year(paid) = @year and month(paid) = @month  and canceldate is null and expired is null  then balance else 0 end)end
		,[PctPaid] = sum(case when year(paid) = @year and month(paid) = @month  and canceldate is null and expired is null  then 1 else 0 end)/convert(float,count(*))
		,[PaidAvgFee] = sum(case when year(paid) = @year and month(paid) = @month and canceldate is null and expired is null then settlementfees else 0 end)/isnull(nullif(sum(case when year(paid) = @year and month(paid) = @month and canceldate is null and expired is null  then 1 else 0 end),0),1)
	from tblsettlementtrackerimports sti inner join tblagency a on a.agencyid = sti.agencyid
	group by sti.agencyid, a.name
	order by a.name

	insert into @tblR 
	select 
		rorder = 1
		,[AgencyName]= 'TOTAL'
		,[TotalFees] = sum(totalfees)
		,[TotalBalance] = sum(totalbalance)
		,[TotalSettAmt] = sum(totalsettamt)
		,[TotalUnits]= sum(totalunits)
		,[TotalAvgPct] = cast(sum(totalsettamt) as float)/isnull(nullif(cast(sum(totalbalance) as float),0),1)
		,[PaidFees] = sum(paidfees)
		,[PaidBalance]= sum(paidbalance)
		,[PaidSettAmt]= sum(paidsettamt)
		,[PaidUnits] = sum(paidunits)
		,[PaidAvgPct]=cast(sum(paidsettamt) as float)/isnull(nullif(cast(sum(paidbalance) as float),0),1)
		,[PctPaid] = cast(sum(paidunits) as float)/isnull(nullif(cast(sum(totalunits) as float),0),1)
		,[PaidAvgFee] = sum(paidfees)/isnull(nullif(sum(paidunits),0),1)
	FROM @tblR

	select [AgencyName]
	,TotalFees = isnull(TotalFees,0)
	,TotalBalance= isnull(TotalBalance,0)
	,TotalSettAmt= isnull(TotalSettAmt,0)
	,TotalUnits= isnull(TotalUnits,0)
	,TotalAvgPct= isnull(TotalAvgPct,0)
	,PaidFees= isnull(PaidFees,0)
	,PaidBalance= isnull(PaidBalance,0)
	,PaidSettAmt= isnull(PaidSettAmt,0)
	,PaidUnits= isnull(PaidUnits,0)
	,PaidAvgPct= isnull(PaidAvgPct,0)
	,PctPaid= isnull(PctPaid,0)
	,[PaidAvgFee] = isnull(PaidAvgFee,0)
	from @tblR where [AgencyName] <> '' and TotalUnits <> 0 and PaidUnits <> 0
	order by rorder


END


GRANT EXEC ON stp_settlementimport_reports_getAgencyTotals TO PUBLIC


