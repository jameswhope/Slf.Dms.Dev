if exists (select * from sysobjects where name = 'stp_BulkNegotiationDashBoardSummary')
	drop procedure stp_BulkNegotiationDashBoardSummary
go

create procedure stp_BulkNegotiationDashBoardSummary
(
	@FilterID int
)
as
begin
/*
	History:
	jhernandez		04/22/08		Created. Similar to stp_NegotiationDashBoardSummary
*/

declare @AggregateClause varchar(max)

SELECT @AggregateClause = AggregateClause from tblNegotiationFilters WHERE FilterId = @FilterId

EXEC 
  ('
   SELECT ' + @FilterId + ' as FilterId,
	Count(Distinct ClientId) As ClientCount, 
	Count(AccountId) as AccountCount, 
	Count(Distinct ApplicantState) as StateCount, 
	Count(Distinct ApplicantZipCode) as ZipCodeCount,
	Count(Distinct CurrentCreditor) as CreditorCount,
	Count(Distinct AccountStatus) as StatusCount,
	Sum(FundsAvailable) as FundsAvailable		   
   FROM 
	dbo.vwNegotiationDistributionSource
   WHERE ((IsNull(AccountStatusId, -1) Not In (54,55,-1)) AND (' + @AggregateClause + ') AND (AccountId not in (select AccountID from tblBulkNegotiationListXref)))')  

end