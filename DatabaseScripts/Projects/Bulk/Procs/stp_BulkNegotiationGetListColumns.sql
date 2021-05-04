if exists (select * from sysobjects where name = 'stp_BulkNegotiationGetListColumns')
	drop procedure stp_BulkNegotiationGetListColumns
go

create procedure stp_BulkNegotiationGetListColumns
@BulkListId int
as
begin
/*
	History:
	opereira		05/05/08		
*/
-- Get columns to display
select 
	f.BulkFieldId,
	f.Display,
	f.TableColumn,
	f.ColumnRequired,
	f.Hidden,
	f.IsReadOnly  
from tblBulkNegotiationFields f 
inner join tblBulkNegotiationListTemplates t on (t.BulkFieldId = f.BulkFieldId)
where t.BulkListId = @BulkListId
order by [sequence] asc

end
 
go
