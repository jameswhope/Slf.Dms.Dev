if exists (select * from sysobjects where name = 'stp_BulkNegotiationAddToList')
	drop procedure stp_BulkNegotiationAddToList
go

create procedure stp_BulkNegotiationAddToList
(
	@BulkListID int
,	@AccountID int
)
as
begin
/*
	History:
	jhernandez		05/06/08		Add an account to a bulk list
*/

-- todo: only check if account is in an active list, need to determine if we want to keep
-- xref lists or remove settled accounts from it

--todo: will need to add optional column information to xref table

if not exists (select 1 from tblBulkNegotiationListXref where AccountID = @AccountID) begin
	insert tblBulkNegotiationListXref (BulkListID,AccountID)
	values (@BulkListID,@AccountID)
end

end