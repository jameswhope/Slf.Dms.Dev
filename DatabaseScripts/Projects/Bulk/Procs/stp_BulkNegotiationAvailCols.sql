if exists (select * from sysobjects where name = 'stp_BulkNegotiationAvailCols')
	drop procedure stp_BulkNegotiationAvailCols
go

create procedure stp_BulkNegotiationAvailCols
(
	@BulkListID int
,	@Hidden bit = 0
)
as
begin
/*
	History:
	jhernandez		05/06/08		Gets available columns to add to existing bulk list
									template.
*/

select 
	BulkFieldID, Display
from 
	tblBulkNegotiationFields
where 
	Hidden = @Hidden
	 and ColumnRequired = 0
	 and BulkFieldID not in (
		select BulkFieldID
		from tblBulkNegotiationListTemplates
		where BulkListID = @BulkListID
	)
order by 
	Display

end