if exists (select * from sysobjects where name = 'stp_BulkNegotiationGetMyBulkLists')
	drop procedure stp_BulkNegotiationGetMyBulkLists
go

create procedure stp_BulkNegotiationGetMyBulkLists
(
	@UserID int
)
as
begin
/*
	History:
	opereira		05/02/08		
*/

Select 
	l.BulkListId AS [BulkListId],
	l.ListName AS [ListName], 
	l.Created AS [DateCreated], 
	l.LastModified AS [DateLastModified], 
	l.LastSent AS [DateLastSent],
	(Select count(distinct a.clientid) 
	 From tblBulkNegotiationListXref x
	 Inner Join tblaccount a on x.accountid = a.accountid
	 Inner Join tblClient c on c.ClientId = a.ClientId
	 Where x.BulkListID = l.BulkListID and c.CurrentClientStatusId Not in (15, 17, 18)) AS [ClientCount] ,
	(Select count(distinct a.accountid) 
	 From tblBulkNegotiationListXref x
	 Inner Join tblaccount a on x.accountid = a.accountid
	 Inner Join tblClient c on c.ClientId = a.ClientId
	 Where x.BulkListID = l.BulkListID and c.CurrentClientStatusId Not in (15, 17, 18)) AS [AccountCount] 
From  tblBulkNegotiationLists l
Where l.OwnedBy = @UserId
Order by l.Created Desc

end