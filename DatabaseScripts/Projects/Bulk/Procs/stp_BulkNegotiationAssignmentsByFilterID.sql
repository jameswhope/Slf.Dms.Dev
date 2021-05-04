if exists (select * from sysobjects where name = 'stp_BulkNegotiationAssignmentsByFilterID')
	drop procedure stp_BulkNegotiationAssignmentsByFilterID
go

create procedure stp_BulkNegotiationAssignmentsByFilterID
(
	@FilterID int
)
as
begin
/*
	History:
	jhernandez		04/29/08		Created. Used for creating a new Bulk list. Called when user
									clicks on one of their My Assignment filters.
	opereira		08/22/08		Modified. Change dynamic to static fields.
*/

declare @AggregateClause varchar(max)

-- get filter clause
SELECT @AggregateClause = AggregateClause from tblNegotiationFilters WHERE FilterId = @FilterId

EXEC ('SELECT SDAAccount, 
	   ApplicantLastName, 
	   ApplicantFirstName, 
	   CurrentCreditorAccountNumber, 
	   AccountId,
	   CurrentAmount,
	   FundsAvailable
FROM vwNegotiationDistributionSource
WHERE ((IsNull(AccountStatusId, -1) Not In (54,55,-1)) AND ( ' + @AggregateClause + ' ) 
       AND (AccountId not in (select AccountID from tblBulkNegotiationListXref)))
ORDER BY ApplicantFirstName')  

end