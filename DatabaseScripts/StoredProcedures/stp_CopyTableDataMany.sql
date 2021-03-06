/****** Object:  StoredProcedure [dbo].[stp_CopyTableDataMany]    Script Date: 11/19/2007 15:26:59 ******/
DROP PROCEDURE [dbo].[stp_CopyTableDataMany]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_CopyTableDataMany]
(
	@database1 varchar(50),	
	@database2 varchar(50),
	@strtables varchar(8000)
)

AS

declare @tables table(c varchar(50))
insert into @tables select * from dbo.SplitStr(@strtables,',')

declare @table varchar(50)
declare c2 cursor for select c from @tables
open c2
fetch next from c2 into @table
while @@fetch_status=0 begin
	exec stp_CopyTableData @database1, @table, @database2, @table
	fetch next from c2 into @table
end

close c2
deallocate c2
GO
