IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getTeamTotals')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getTeamTotals
	END

GO

create procedure stp_settlementimport_reports_getTeamTotals
(
@year int,
@month int
)
as
BEGIN
	declare @tblR table(rOrder int,TeamName varchar(100), TotalFees money,TotalBalance money,TotalSettAmt money,TotalUnits int,TotalAvgPct float,PaidFees money,PaidBalance money,PaidSettAmt money,PaidUnits int,PaidAvgPct float,PctPaid float,[PaidAvgFee] money)
insert into @tblR 
select 
rOrder = 0
,[TeamName]= team 
,[TotalFees] = sum(case when year(date) = @year and month(date) = @month then settlementfees else 0 end)
,[TotalBalance] = sum(case when year(date) = @year and month(date) = @month then balance else 0 end)
,[TotalSettAmt] = sum(case when year(date) = @year and month(date) = @month then settlementamt else 0 end)
,[TotalUnits]= sum(case when year(date) = @year and month(date) = @month then 1 else 0 end)
,[TotalAvgPct] = case when sum(case when year(date) = @year and month(date) = @month then balance else 0 end)=0 then 0 else sum(case when year(date) = @year and month(date) = @month then settlementamt else 0 end)/sum(case when year(date) = @year and month(date) = @month then balance else 0 end)end
,[PaidFees] = sum(case when year(paid) = @year and month(paid) = @month and canceldate is null and expired is null then settlementfees else 0 end)
,[PaidBalance]= sum(case when year(paid) = @year and month(paid) = @month and canceldate is null and expired is null  then balance else 0 end)
,[PaidSettAmt]= sum(case when year(paid) = @year and month(paid) = @month and canceldate is null and expired is null  then settlementamt else 0 end)
,[PaidUnits] = sum(case when year(paid) = @year and month(paid) = @month and canceldate is null and expired is null  then 1 else 0 end)
,[PaidAvgPct]=case when sum(case when year(paid) = @year and month(paid) = @month and canceldate is null and expired is null  then balance else 0 end) = 0 then 0 else sum(case when year(paid) = @year and month(paid) = @month and canceldate is null and expired is null  then settlementamt else 0 end)/sum(case when year(paid) = @year and month(paid) = @month then balance else 0 end)end
,[PctPaid] = sum(case when year(paid) = @year and month(paid) = @month then 1 else 0 end)/convert(float,count(*))
,[PaidAvgFee] = sum(case when year(paid) = @year and month(paid) = @month and canceldate is null and expired is null then settlementfees else 0 end)/isnull(nullif(sum(case when year(paid) = @year and month(paid) = @month and canceldate is null and expired is null  then 1 else 0 end),0),1)
from tblsettlementtrackerimports sti 
--where canceldate is null and expired is null
group by team
having sum(case when year(paid) = @year and month(paid) = @month and not paid is null then 1 else 0 end)>=1
order by team

insert into @tblR 
select 
rorder = 1
,[TeamName]= 'TOTAL'
,[TotalFees] = sum(totalfees)
,[TotalBalance] = sum(totalbalance)
,[TotalSettAmt] = sum(totalsettamt)
,[TotalUnits]= sum(totalunits)
,[TotalAvgPct] = sum(totalsettamt)/isnull(nullif(sum(totalbalance),0),1)
,[PaidFees] = sum(paidfees)
,[PaidBalance]= sum(paidbalance)
,[PaidSettAmt]= sum(paidsettamt)
,[PaidUnits] = sum(paidunits)
,[PaidAvgPct]=sum(paidsettamt)/isnull(nullif(sum(paidbalance),0),1)
,[PctPaid] = cast(sum(paidunits) as float)/cast(isnull(nullif(sum(totalunits),0),1) as float)
,[PaidAvgFee] = sum(paidfees)/isnull(nullif(sum(paidunits),0),1)
FROM @tblR

select TeamName
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
,PaidAvgFee = isnull(PaidAvgFee ,0)
from @tblR where TeamName <> ''	order by rorder


END


GO


GRANT EXEC ON stp_settlementimport_reports_getTeamTotals TO PUBLIC

GO


