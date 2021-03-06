/****** Object:  StoredProcedure [dbo].[stp_HomepageChartReceivable]    Script Date: 11/19/2007 15:27:22 ******/
DROP PROCEDURE [dbo].[stp_HomepageChartReceivable]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_HomepageChartReceivable]
 (
  @refwhere varchar (8000) = '',
  @dategrouping int = 0
 )
 
as
 

declare @datefield varchar (500)
declare @field varchar(50)
set @field='#tmp.TransactionDate'

if @dategrouping = 0 -- daily grouping
	begin
		set @datefield = 'convert(datetime, convert(varchar, ' + @field + ', 101))'
	end
else if @dategrouping = 1 -- weekly grouping
	begin
		set @datefield = 'dateadd(day, 1 - datepart(dw, ( convert(varchar, ' + @field + ', 101) )), ( convert(varchar, ' + @field + ', 101) ))'
	end
else if @dategrouping = 2 -- monthly grouping
	begin
		set @datefield = 'convert(datetime, convert(varchar(2), month(' + @field + ')) + N''/1/'' + convert(varchar(4), year(' + @field + ')))'
	end
else if @dategrouping = 3 -- yearly grouping
	begin
		set @datefield = 'convert(datetime, N''1/1/'' + convert(varchar(12), year(' + @field + ')))'
	end


create table #tmp(
	RegisterId int,
	AgencyId int,
	TransactionDate datetime,
	Amount money
)

exec('
INSERT INTO
	#tmp
SELECT 
	tblRegister.RegisterID,
	tblClient.AgencyId,
	tblRegister.TransactionDate,
	(-tblRegister.Amount-
		(SELECT 
			case when SUM(b.Amount) is null then 0 else sum(b.amount) end
		FROM 
			tblRegisterPayment b
		WHERE 
			b.FeeRegisterId=tblRegister.RegisterId
		)
	)*tblcommfee.[percent] as Amount

FROM
	tblRegister INNER JOIN 
	tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId INNER JOIN
	tblClient ON tblRegister.ClientId=tblClient.ClientId INNER JOIN
	(SELECT distinct ClientId,Created as HireDate FROM tblRoadmap WHERE ClientStatusId=5) tblHireDate ON tblClient.ClientId=tblHireDate.ClientId INNER JOIN
	tblAgency ON tblClient.AgencyId=tblAgency.AgencyId INNER JOIN
	tblCommScen ON tblClient.AgencyId=tblCommScen.AgencyId AND tblHireDate.HireDate > tblCommScen.StartDate AND (tblHireDate.HireDate<tblCommScen.EndDate OR tblCommScen.EndDate is null) INNER JOIN
	tblCommStruct ON tblCommScen.CommScenId=tblCommStruct.CommScenId INNER JOIN
	tblCommFee ON (tblRegister.EntryTypeId=tblCommFee.EntryTypeId AND tblCommFee.CommStructId=tblCommStruct.CommStructId)
WHERE
	tblEntryType.Fee=1 ' + @refwhere
)

exec
('
select
	tbl.date as [time],	
	sum(Amount) as Amount
from
	(select *, ' + @datefield + ' as date from #tmp) as tbl
where
	Amount > 0
group by
   tbl.date
having
   not tbl.date is null
order by 
   tbl.date'
)

drop table #tmp
GO
