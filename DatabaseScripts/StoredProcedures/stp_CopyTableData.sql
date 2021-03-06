/****** Object:  StoredProcedure [dbo].[stp_CopyTableData]    Script Date: 11/19/2007 15:26:59 ******/
DROP PROCEDURE [dbo].[stp_CopyTableData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[stp_CopyTableData]
(
	@database1 varchar(50),	
	@table1 varchar(50),
	@database2 varchar(50),
	@table2 varchar(50)
)

AS

--Get the list of columns to copy
create table #tmpColumns1(c varchar(50))
create table #tmpColumns2(c varchar(50))

exec
(' 
use ' + @database2 + '
insert into #tmpColumns1(c) select column_name from information_schema.columns where table_name=''' + @table1 + '''
')

exec
(' 
use ' + @database1 + '
insert into #tmpColumns2(c) select column_name from information_schema.columns where table_name=''' + @table2 + '''
')

declare @colList varchar(8000)
set @colList=''
declare @col varchar(50)
declare c cursor for select t1.c from #tmpcolumns1 t1 inner join #tmpcolumns2 t2 on t1.c=t2.c
open c
fetch next from c into @col
while @@fetch_status=0 begin
	if len(@colList)>0 set @colList = @colList + ','
	set @colList=@colList + '[' + @col + ']'
	fetch next from c into @col
end
close c
deallocate c

drop table #tmpcolumns1
drop table #tmpcolumns2

exec('truncate table ' + @database2 + '.dbo.' + @table2)

exec('
set identity_insert ' + @database2 + '.dbo.' + @table2 + ' on
insert into ' + @database2 + '.dbo.' + @table2 + '(' + @collist + ') select ' + @collist + ' from ' + @database1 + '.dbo.' + @table1 + '
set identity_insert ' + @database2 + '.dbo.' + @table2 + ' off
')
GO
