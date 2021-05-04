IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationSiblingFilterExclusion')
	BEGIN
		DROP  Procedure  stp_NegotiationSiblingFilterExclusion
	END
BEGIN

EXEC dbo.sp_executesql @statement = N'

/*
	Author: Bereket S. Data
	Description: Check for any overlap that may be caused by intended criteria addition. 
				 The indended criteria to be added is passed as a paramter (@filterClause).
				 When creating a sub-criteria, the entity(@ParentFilter) is always passed as a paramter also.
*/
CREATE PROCEDURE [dbo].[stp_NegotiationSiblingFilterExclusion]
@ParentEntityId int,
@SourceFilterId int,
@filterClause varchar(max)

AS
SET NOCOUNT ON
DECLARE @LocalfilterClause varchar(max)
DECLARE @FilterId int
DECLARE @PreviousFilterId int
DECLARE @tblOrFilter TABLE (FilterId int,filterClause varchar(max), isRead int)
CREATE TABLE #tblAssignedList(FilterId int, AccountId int)
DECLARE @tblAggregate TABLE (FilterClause varchar(max))
DECLARE @ParentFilterClause varchar(max)
SET @FilterId = null
SET @LocalfilterClause = null

if @SourceFilterId > 0 
 BEGIN
	INSERT INTO @tblOrFilter
   	  SELECT FilterId, FilterClause, ''0''
		FROM tblNegotiationFilters 
		WHERE EntityId = @ParentEntityId and ParentFilterId is null and GroupBy is null
	    AND FilterType = ''stem'' AND FilterId NOT IN(@SourceFilterId)	  
 END
else
 BEGIN
	INSERT INTO @tblOrFilter
	  SELECT FilterId, filterClause, ''0''
		FROM tblNegotiationFilters 
		WHERE EntityId = @ParentEntityId and ParentFilterId is null and GroupBy is null
	    AND FilterType = ''stem''
 END


INSERT INTO @tblAggregate
   exec stp_NegotiationSiblingBaseFilterSelect @ParentEntityId

SELECT @ParentFilterClause = FilterClause from @tblAggregate 
SET  @ParentFilterClause = isnull(@ParentFilterClause,''1=1'')

   
SELECT TOP 1 @LocalfilterClause = filterClause, @FilterId = FilterId FROM @tblOrFilter WHERE isRead = 0

WHILE @FilterId > 0
 BEGIN
    SET @PreviousFilterId = @FilterId    
	EXEC 
	(''
		INSERT INTO #tblAssignedList       
		SELECT DISTINCT '' + @FilterId + '', AccountId 
		FROM dbo.vwNegotiationDistributionSource        
		WHERE 1=1 AND ( '' + @filterClause + '' )  AND  ( '' + @LocalfilterClause + '') AND ('' + @ParentFilterClause + '')''
	)	 

	UPDATE @tblOrFilter SET isRead = 1 WHERE FilterId = @FilterId
    SELECT TOP 1 @LocalfilterClause = filterClause, @FilterId = FilterId FROM @tblOrFilter WHERE isRead = 0
    if @PreviousFilterId = @FilterId
     BEGIN
       SET @FilterId = 0
     END
 END

 SELECT DISTINCT isnull(FilterId,0) as FilterId FROM #tblAssignedList

DROP TABLE #tblAssignedList

'
END

GO