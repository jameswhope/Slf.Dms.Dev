if exists (select * from sysobjects where name = 'stp_BulkNegotiationGetAllColumns')
	drop procedure stp_BulkNegotiationGetAllColumns
go

create procedure  stp_BulkNegotiationGetAllColumns 
as
begin
/*
	History:
	opereira		05/12/08		
*/
-- Get all columns  
select 
	f.BulkFieldId,
	f.Display,
	f.TableColumn,
	f.ColumnRequired,
	f.Hidden,
	f.IsReadOnly  
from tblBulkNegotiationFields f 
order by f.BulkFieldID

end

go
