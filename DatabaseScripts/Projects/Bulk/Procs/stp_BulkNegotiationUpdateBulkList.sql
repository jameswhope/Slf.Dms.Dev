IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_BulkNegotiationUpdateBulkList')
	BEGIN
		DROP  Procedure  stp_BulkNegotiationUpdateBulkList
	END

GO

CREATE Procedure stp_BulkNegotiationUpdateBulkList
(
@BulkListId int,
@AccountId int,
@LastOfferMade varchar(10) = NULL,
@LastOfferReceived varchar(10) = NULL,
@LastNote varchar(1000) =  NULL,
@LastModifiedDate datetime,
@LastModifiedBy int
)
AS
BEGIN
/*
	History:
	opereira		05/15/08		Update changes in BulkList
	jhope			05/19/08		Added Modified and ModifiedBy for update.
*/	

Update tblBulkNegotiationListXref Set
LastOfferMade = @LastOfferMade,
LastOfferReceived = @LastOfferReceived,
Notes = @LastNote
Where BulkListId = @BulkListId
And AccountId = @AccountId

Update tblBulkNegotiationLists Set
LastModified = @LastModifiedDate,
LastModifiedBy = @LastModifiedBy
WHERE BulkListID = @BulkListID


END 

GO



