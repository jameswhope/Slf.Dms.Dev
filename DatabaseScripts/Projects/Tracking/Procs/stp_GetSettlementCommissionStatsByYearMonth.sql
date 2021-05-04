IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSettlementCommissionStatsByYearMonth')
	BEGIN
		DROP  Procedure  stp_GetSettlementCommissionStatsByYearMonth
	END

GO

CREATE Procedure stp_GetSettlementCommissionStatsByYearMonth
(
@StatisticYear int,
@StatisticMonth int
)
as
declare @vtblStats table
(
Userid int,
[IncentiveMonth] int,
[IncentiveYear] int,
TotalUnits int,
Rate money,
TotalPayout money,
TotalAcctBal money,
TotalSettlementsAmt money,
TotalSettlementFees money,
TotalAvgPercentage float,
IncentiveRate float,
IncentiveAdj money,
TotalIncentivePaid money
)

declare @Month int, @Units int, @rate float

insert into @vtblStats
select 
	createdby as [userid],
	month(created) as [IncentiveMonth],
	year(created) as [IncentiveYear],
	count(*) as [TotalUnits], 
	null as [rate],
	null as totalpayout,
	sum(creditoraccountbalance) as [TotalAcctBal],
	sum(settlementamount) as [TotalSettlementsAmt],
	sum(settlementfee) as [TotalSettlementFees],
	null as TotalAvgPercentage,
	null as IncentiveRate ,
	null as IncentiveAdj,
	null as TotalIncentivePaid 
from tblsettlements as s
group by createdby,year(created),month(created)


declare cur_Stats cursor local for select [IncentiveMonth] , TotalUnits , rate from @vtblStats
open cur_Stats
fetch next from cur_Stats into @Month , @Units , @rate 
while @@fetch_status = 0 
	BEGIN
		print @units
		update @vtblStats
		set rate = (select top 1 rate from dbo.tblSettementIncentives_RatePerSettlement where @units between beginrange and endrange  order by  settlementunits desc)
		where TotalUnits = @units

		fetch next from cur_Stats into @Month , @Units , @rate 
	END
close cur_Stats
deallocate cur_Stats

update @vtblStats
set totalpayout = rate*totalunits

update @vtblStats
set TotalAvgPercentage = [TotalSettlementsAmt]/[TotalAcctBal]*100

update @vtblStats
set IncentiveRate = (select settlementpercentagerate from dbo.tblSettementIncentives_SettlementAvgRate where
cast(TotalAvgPercentage as numeric) between AvgSettlementPercentageStartRange and AvgSettlementPercentageEndRange )

update @vtblStats
set IncentiveAdj = totalpayout*(IncentiveRate/100)

update @vtblStats
set TotalIncentivePaid = totalpayout+IncentiveAdj
/*get groups*/
declare @vtblGroups table
(
	groupName varchar(30),
	groupID int
)
insert into @vtblGroups
select distinct name, negotiationentityid from dbo.tblNegotiationEntity where type = 'group' and deleted <> 1

declare @vtblList table
(
	GroupName Varchar(30),
	UserName varchar(200),
	EntityID int,
	UserID int
)

declare @groupName varchar(200)
declare @groupID int

declare cur_List cursor local for select groupname, groupID from @vtblGroups
open cur_List
fetch next from cur_List into @groupName, @groupID
while @@fetch_status = 0 
	BEGIN
		insert into @vtblList
		select distinct @groupname, name,negotiationentityid,userid from tblNegotiationEntity where parentnegotiationentityid = @groupID and deleted <> 1
		fetch next from cur_List into @groupName, @groupID
	END
close cur_List
deallocate cur_List

declare cur_List cursor local for select groupname,  entityID from @vtblList
open cur_List
fetch next from cur_List into @groupName, @groupID
while @@fetch_status = 0 
	BEGIN
		insert into @vtblList
		select distinct @groupname, name,negotiationentityid,userid from tblNegotiationEntity where parentnegotiationentityid = @groupID and deleted <> 1
		fetch next from cur_List into @groupName, @groupID
	END
close cur_List
deallocate cur_List


select u.groupname,u.username ,s.* 
from @vtblStats as s inner join @vtblList as u on s.userid=u.userid
where [IncentiveYear] = @StatisticYear and [IncentiveMonth] = @StatisticMonth 
order by u.groupname,u.username,[IncentiveYear], [IncentiveMonth]



GRANT EXEC ON stp_GetSettlementCommissionStatsByYearMonth TO PUBLIC

