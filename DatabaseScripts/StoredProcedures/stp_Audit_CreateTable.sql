/****** Object:  StoredProcedure [dbo].[stp_Audit_CreateTable]    Script Date: 11/19/2007 15:26:54 ******/
DROP PROCEDURE [dbo].[stp_Audit_CreateTable]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_Audit_CreateTable]
(
	@tablename varchar(50), 
	@pkcolumn varchar(50) = null
)

AS

if @pkcolumn is null
	set @pkcolumn = substring(@tablename,4,len(@tablename)) + 'ID'

print 'Primary key column is ' + @pkcolumn

declare @audittableid int

set @audittableid=(select audittableid from tblaudittable where [name]=@tablename)
if @audittableid is null begin
	insert into tblaudittable([name],pkcolumn) values (@tablename,@pkcolumn)
	set @audittableid=scope_identity()
end

declare @column varchar(50)
declare @isbigvalue bit

declare c cursor for
	select 
		column_name,
		(case 
			when data_type in ('text', 'ntext', 'image') then 1
			else 0
		end) as IsBigValue
	from 
		information_schema.columns
	where 
		table_name=@tablename
		and not column_name like ('created%')
		and not column_name like ('lastmodified%')
		and not column_name = 'UC'
		and not column_name = 'DC'
		and not column_name = @pkcolumn
open c
fetch next from c into @column, @isbigvalue
while @@fetch_status=0 begin
	if not exists (select auditcolumnid from tblauditcolumn where audittableid=@audittableid and [name]=@column) begin
		insert into tblauditcolumn(audittableid,[name],isbigvalue)
		values (@audittableid,@column,@isbigvalue)	
	end

	fetch next from c into @column, @isbigvalue
end
close c
deallocate c
GO
