/****** Object:  StoredProcedure [dbo].[stp_HomepageChartServiceFees]    Script Date: 11/19/2007 15:27:22 ******/
DROP PROCEDURE [dbo].[stp_HomepageChartServiceFees]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_HomepageChartServiceFees]
 (
  @refwhere varchar (8000) = '',
  @dategrouping int = 0
 )
 
as
 


--declare @dategrouping int 
--set @dategrouping= 0

declare @datefield varchar (500)
declare @field varchar(50)
set @field='#tmp.batchdate'

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
 

create table #tmp(amount money,batchdate datetime, agencyid int)

insert into
	#tmp (amount, batchdate, agencyid)
select
	tblcommpay.amount as amount,
	tblcommbatch.batchdate,
	tblcommscen.agencyid
from
	tblcommbatch inner join
	tblcommpay on tblcommbatch.commbatchid=tblcommpay.commbatchid inner join
	tblcommscen on tblcommbatch.commscenid=tblcommscen.commscenid


union all

select
	tblcommchargeback.amount as amount,
	tblcommbatch.batchdate,
	tblcommscen.agencyid
from
	tblcommbatch inner join
	tblcommchargeback on tblcommbatch.commbatchid=tblcommchargeback.commbatchid inner join
	tblcommscen on tblcommbatch.commscenid=tblcommscen.commscenid

exec
('
select
	sum(amount) as amount,
	tbl.date as [time]
	
from
	(select *, ' + @datefield + ' as date from #tmp) as tbl
group by
   tbl.date
having
   not tbl.date is null
order by 
   tbl.date'
)

drop table #tmp
GO
