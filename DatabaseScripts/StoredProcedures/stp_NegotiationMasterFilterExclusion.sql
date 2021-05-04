

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationMasterFilterExclusion]') AND type in (N'P', N'PC'))
BEGIN
DROP PROCEDURE stp_NegotiationMasterFilterExclusion
END
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
	Author: Bereket S. Data
	Description: Check for any overlap that may be caused by intended criteria addition.  
				 The indended criteria to be added is passed as a paramter (@filterClause).   				 

*/

CREATE PROCEDURE [dbo].[stp_NegotiationMasterFilterExclusion]
@SourceFilterId int,
@filterClause varchar(max)

AS
SET NOCOUNT ON
DECLARE @LocalfilterClause varchar(max)
DECLARE @FilterId int
DECLARE @PreviousFilterId int
DECLARE @tblOrFilter TABLE (FilterId int,filterClause varchar(max), isRead int)
CREATE TABLE #tblAssignedList(FilterId int, AccountId int)

SET @FilterId = null
SET @LocalfilterClause = null

if @SourceFilterId > 0 
 BEGIN
	INSERT INTO @tblOrFilter
	  SELECT FilterId, FilterClause, ''0'' FROM tblNegotiationFilters WHERE FilterId NOT IN(@SourceFilterId) and FilterType = ''root''
 END
else
 BEGIN
	INSERT INTO @tblOrFilter
	  SELECT FilterId, FilterClause, ''0'' FROM tblNegotiationFilters WHERE FilterType = ''root''
 END
   
SELECT TOP 1 @LocalfilterClause = filterClause, @FilterId = FilterId FROM @tblOrFilter WHERE isRead = 0

WHILE @FilterId > 0
 BEGIN
    SET @PreviousFilterId = @FilterId    
	EXEC 
	(''
		INSERT INTO #tblAssignedList       
		SELECT DISTINCT '' + @FilterId + '', AccountId 
		FROM dbo.vwNegotiationDistributionSource        
		WHERE 1=1 AND ( '' + @filterClause + '' )  AND  ( '' + @LocalfilterClause + '')''
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