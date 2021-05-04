if exists (select * from sysobjects where name = 'stp_BulkNegotiationGetDefaultColumns')
	drop procedure stp_BulkNegotiationGetDefaultColumns
go

create procedure stp_BulkNegotiationGetDefaultColumns
as
begin
/*
	History:
	opereira		05/05/08		
*/
-- Get default columns to display
select 
	BulkFieldId,
	Display,
	TableColumn,
	ColumnRequired,
	Hidden,
	IsReadOnly  
from tblBulkNegotiationFields 
where ColumnRequired = 1
order by BulkFieldId

end
 
go