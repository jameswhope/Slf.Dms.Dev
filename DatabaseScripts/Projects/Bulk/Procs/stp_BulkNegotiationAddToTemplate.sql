if exists (select * from sysobjects where name = 'stp_BulkNegotiationAddToTemplate')
	drop procedure stp_BulkNegotiationAddToTemplate
go

create procedure stp_BulkNegotiationAddToTemplate
(
	@BulkListID int
,	@BulkFieldID int
,   @Sequence int = Null
)
as
begin
/*
	History:
	jhernandez		05/07/08		Adds a field to a bulk list template
	opereira		05/15/08		Adds the sequence field
*/

if @Sequence is Null 
	Select @Sequence = 1 + (Select Max([Sequence]) from tblBulkNegotiationListTemplates
	Where BulkListId = @BulkListId and BulkFieldId = @BulkFieldId) 

Select @Sequence = isnull(@Sequence, 0)

if not exists (select 1 from tblBulkNegotiationListTemplates where BulkListID = @BulkListID and BulkFieldID = @BulkFieldID) 
	begin
		insert tblBulkNegotiationListTemplates (BulkListID,BulkFieldID, [Sequence])
		values (@BulkListID,@BulkFieldID, @Sequence)
	end
Else 
	begin
		update tblBulkNegotiationListTemplates set [Sequence] = @Sequence
		where BulkListId = @BulkListId and BulkFieldId = @BulkFieldId
	end

end

go