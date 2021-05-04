if exists (select * from sysobjects where name = 'stp_BulkNegotiationRemoveFromList')
	drop procedure stp_BulkNegotiationRemoveFromList
go

create procedure stp_BulkNegotiationRemoveFromList
(
	@BulkListID int
,	@AccountID int
)
as
begin
/*
	History:
	jhernandez		05/09/08		Created.
*/

delete from tblBulkNegotiationListXref 
where BulkListID = @BulkListID
  and AccountID = @AccountID
	

end