IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationSiblingDashBoardSummary')
	BEGIN
		DROP  Procedure  stp_NegotiationSiblingDashBoardSummary
	END

BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
	Author: Bereket S. Data
	Description: Retrieves dashboard items for sub-criteria filters. 
				 All sub-criteria filter have theri filter type set to ''stem''
				 NOTE: All sub-criteria filters created through criteria builder have their ParentFilterId and GroupBy fields set to null

*/
CREATE PROCEDURE [dbo].[stp_NegotiationSiblingDashBoardSummary]
@ParentFilterId int,
@FilterId int,
@GridFilterClause varchar(max) = null

AS

SET NOCOUNT ON

if @FilterId = ''0''
BEGIN
	SET @FilterId = null
END

if @GridFilterClause = ''''
BEGIN
	SET @GridFilterClause = null
END

DECLARE @EntityId int
DECLARE @FilterClause varchar(max)
DECLARE @ParentFilterClause varchar(max)
DECLARE @LocalFilterId int
DECLARE @PreviousFilterId int
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


INSERT INTO @tblAggregate
   exec stp_NegotiationSiblingBaseFilterSelect @ParentFilterId


SELECT @ParentFilterClause = FilterClause from @tblAggregate 

SET  @GridFilterClause = isnull(@GridFilterClause,''1=1'')
SET  @ParentFilterClause = isnull(@ParentFilterClause,''1=1'')




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
				   WHERE 1=1 AND  ( '' + @GridFilterClause + '' ) AND ('' + @ParentFilterClause + '') '' 
				  )  		
  END
else if @FilterId is null 
  BEGIN
   INSERT INTO @tblFilterList
    SELECT FilterId,FilterClause,''0'' FROM tblNegotiationFilters WHERE FilterId = isnull(@FilterId,FilterId) and FilterType = ''stem'' and ParentFilterId is null
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
				   WHERE 1=1 AND  ( '' + @FilterClause + '' ) AND ('' + @ParentFilterClause + '') '' 
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
     SELECT @FilterClause = FilterClause FROM tblNegotiationFilters WHERE FilterId = @FilterId

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
		   WHERE 1=1 AND  ('' +  @FilterClause + '' ) AND ('' + @ParentFilterClause + '') '' 
		  )  		   
 END


SELECT * FROM @tblDashBoard

'
END
GO
