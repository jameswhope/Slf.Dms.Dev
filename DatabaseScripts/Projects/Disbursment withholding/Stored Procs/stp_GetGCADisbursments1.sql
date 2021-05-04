IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetTodaysGCADisbursments1')
	BEGIN
		DROP  Procedure  stp_GetTodaysGCADisbursments1
	END

GO

CREATE Procedure stp_GetTodaysGCADisbursments1
	@dDate datetime
AS

--DECLARE @dDate datetime

--set @dDate = cast(getdate() as varchar(12))
---SET @dDate = '06/20/2011'

DECLARE @CompanyID int
DECLARE @DepositAmount money

create table #tmpGCA1
(
CompanyID int,
[Disbursment date] varchar(15),
[Clearing Account] varchar(100),
[Today's planned payout] varchar(12),
[Today's Account balance] varchar(12),
[Today's Deposits] varchar(12),
[Ending Balance] varchar(12),
[Over Drawn] bit
)

Insert into #tmpGCA1

SELECT cbt.companyid
, cast(cb.BatchDate AS varchar(12)) as [Disbursment date]
, cr.Display as [Clearing Account]
, '$' + cast(sum(cbt.transferAmount) AS varchar(10)) as [Today's planned payout]
, '$0.00' as [Today's Account Balance]
, '$0.00' as [Today's Deposts]
, '$' + cast((0 + 0) - sum(cbt.TransferAmount) AS varchar(10)) as [Ending Balance]
, CASE when 0 - sum(cbt.TransferAmount) < 0 then 'true' else null end as [Over drawn] 
FROM tblcommbatch cb
JOIN tblCommBatchTransfer cbt ON cbt.CommBatchID = cb.commbatchid
JOIN tblCommRec cr ON cr.CommRecID= cbt.ParentCommRecID
where cb.BatchDate > @ddate
AND cr.Display LIKE '%Clearing%'
AND TrustID > 20
GROUP BY cr.Display, cbt.companyid, cast(cb.BatchDate AS varchar(12))

DECLARE c_TodaysDeposits cursor for
select companyid
, sum(case when flow = 'credit' then amount end) --else -amount 
from tblnacharegister2
where created > @dDate
and name like '%clearing%'
and nachafileid = -1
group by companyid

open c_TodaysDeposits

fetch next from c_TodaysDeposits into @CompanyID, @DepositAmount
while @@fetch_status = 0
begin
	update #tmpGCA1 SET [Today's Deposits] = '$' + cast(@DepositAmount AS varchar(10)),
	[Ending Balance] = '$' + cast((cast([Today's Account balance] AS money) 
	+ @DepositAmount) 
	- cast([Today's planned payout] AS money) as varchar(12))
	WHERE CompanyID = @CompanyID
	fetch next from c_TodaysDeposits into @CompanyID, @DepositAmount
end

CLOSE c_TodaysDeposits
Deallocate c_TodaysDeposits

SELECT * from #tmpGCA1

drop table #tmpGCA1

GO

/*
GRANT EXEC ON stp_GetTodaysGCADisbursments1 TO PUBLIC

GO
*/

