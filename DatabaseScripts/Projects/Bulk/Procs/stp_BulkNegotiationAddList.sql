IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_BulkNegotiationAddList')
	BEGIN
		DROP  Procedure  stp_BulkNegotiationAddList
	END

GO

CREATE Procedure stp_BulkNegotiationAddList
(
	@ListName varchar(50)
,	@CreatedBy int 
,	@OwnedBy int
)
as
begin
/*
	History:
	jhernandez		05/06/08		Returns BulkListID
	Jim Hope		05/15/2008		Check is list exists for owner
*/

IF NOT EXISTS (SELECT 1 FROM tblBulkNegotiationLists WHERE ListName = @ListName AND OwnedBy = @OwnedBy)
BEGIN
	insert tblBulkNegotiationLists (ListName,Created,CreatedBy,OwnedBy)
	values (@ListName,getdate(),@CreatedBy,@OwnedBy)
	select scope_identity()
END

end

GO


