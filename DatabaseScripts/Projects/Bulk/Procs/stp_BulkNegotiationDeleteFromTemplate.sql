if exists (select * from sysobjects where name = 'stp_BulkNegotiationDeleteFromTemplate')
	drop procedure stp_BulkNegotiationDeleteFromTemplate
go

create procedure stp_BulkNegotiationDeleteFromTemplate
(
	@BulkListID int,
	@BulkFieldID int
)
as
begin
/*
	History:
	opereira		05/08/08		deletes a field to a bulk list template
*/

	delete from tblBulkNegotiationListTemplates Where BulkListID = @BulkListID and BulkFieldID = @BulkFieldID

end