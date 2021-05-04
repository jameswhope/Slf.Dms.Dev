
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationDashBoardSummary]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE stp_NegotiationDashBoardSummary
END
GO

BEGIN
EXEC dbo.sp_executesql @statement = N'


/*
	Author: Bereket S. Data
	Description: Retrieves dashboard items for master criteria filters.   
			     All master criteria filter have theri filter type set to ''root''. 
			     NOTE: All master criteria filters created through criteria builder have their ParentFilterId set to null.

*/

CREATE PROCEDURE [dbo].[stp_NegotiationDashBoardSummary]
@FilterId int,
@GridFilterClause varchar(max) = null

AS
SET NOCOUNT ON

if @FilterId = 0
BEGIN
	SET @FilterId = null
END

DECLARE @FilterClause varchar(max)
DECLARE @LocalFilterId int
DECLARE @PreviousFilterId int
DECLARE @AggregateClause varchar(max)

DECLARE @tblAggregate TABLE (FilterClause varchar(max))
DECLARE @tblDashBoard TABLE (FilterId int, ClientCount int,
						   AccountCount int, 
						   StateCount int,
						   ZipCodeCount int,
						   CreditorCount int,
				           StatusCount int,
						   TotalSDAAmount money)

DECLARE @tblFilterList TABLE(FilterId int, 
                               filterClause varchar(max), 
                               isRead int)

SET @FilterClause = null
SET @LocalFilterId = null
SET @PreviousFilterId = null
SET @FilterClause = null


SET  @GridFilterClause = isnull(@GridFilterClause,''1=1'')

if not @GridFilterClause = ''1=1'' And @FilterId is Null
  BEGIN
			 INSERT INTO @tblDashBoard
				EXEC 
				  (''
				   SELECT 0 as MasterListId,Count(Distinct ClientId) As ClientCount, 
				   Count(AccountId) as AccountCount, 
				   Count(Distinct ApplicantState) as StateCount, 
				   Count(Distinct ApplicantZipCode) as ZipCodeCount,
				   Count(Distinct CurrentCreditor) as CreditorCount,
				   Count(Distinct AccountStatus) as StatusCount,
				   Sum(FundsAvailable) as FundsAvailable   
				   FROM dbo.vwNegotiationDistributionSource
				   WHERE 1=1 AND  ( '' + @GridFilterClause + '' ) '' 
				  )  		
  END
else if @FilterId is null 
  BEGIN
   INSERT INTO @tblFilterList
    SELECT FilterId,FilterClause,''0'' FROM tblNegotiationFilters WHERE FilterId = isnull(@FilterId,FilterId) and FilterType = ''root''
	SELECT TOP 1 @FilterClause = filterClause, @LocalFilterId = FilterId FROM @tblFilterList WHERE isRead = 0

		WHILE @LocalFilterId > 0
		 BEGIN
			 SET @PreviousFilterId = @LocalFilterId
			 
			 INSERT INTO @tblDashBoard
				EXEC 
				  (''
				   SELECT '' + @LocalFilterId + '' as MasterListId,Count(Distinct ClientId) As ClientCount, 
				   Count(AccountId) as AccountCount, 
				   Count(Distinct ApplicantState) as StateCount, 
				   Count(Distinct ApplicantZipCode) as ZipCodeCount,
				   Count(Distinct CurrentCreditor) as CreditorCount,
				   Count(Distinct AccountStatus) as StatusCount,
				   Sum(FundsAvailable) as FundsAvailable   
				   FROM dbo.vwNegotiationDistributionSource
				   WHERE 1=1 AND  ( '' + @FilterClause + '' ) '' 
				  )  		

			 UPDATE @tblFilterList SET isRead = 1 WHERE FilterId = @LocalFilterId    
			 SELECT TOP 1 @FilterClause = FilterClause, @LocalFilterId = FilterId FROM @tblFilterList WHERE isRead = 0
			 if @PreviousFilterId = @LocalFilterId
			 BEGIN
			   SET @LocalFilterId = 0
			 END
		 END   
  END
else
 BEGIN
     SET @AggregateClause = NULL
	 -- INSERT INTO @tblAggregate
     -- exec stp_NegotiationBaseFilterSelect @FilterId

     SELECT @AggregateClause = AggregateClause from tblNegotiationFilters WHERE FilterId = @FilterId
	 INSERT INTO @tblDashBoard
		EXEC 
		  (''
		   SELECT '' + @FilterId + '' as MasterListId,Count(Distinct ClientId) As ClientCount, 
		   Count(AccountId) as AccountCount, 
		   Count(Distinct ApplicantState) as StateCount, 
		   Count(Distinct ApplicantZipCode) as ZipCodeCount,
		   Count(Distinct CurrentCreditor) as CreditorCount,
		   Count(Distinct AccountStatus) as StatusCount,
		   Sum(FundsAvailable) as FundsAvailable		   
		   FROM dbo.vwNegotiationDistributionSource
		   WHERE 1=1 AND  ( '' + @AggregateClause + '' ) AND ('' +  @GridFilterClause + '')''
		  )  		   
 END


SELECT * FROM @tblDashBoard



' 
END
GO