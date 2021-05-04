
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationFilterAggregateUpdate]') AND type in (N'P', N'PC'))
BEGIN
 DROP PROCEDURE stp_NegotiationFilterAggregateUpdate
END
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
	Author: Bereket S. Data
	Description: Aggregates filter clause for a given  criteria filter
*/

CREATE PROCEDURE [dbo].[stp_NegotiationFilterAggregateUpdate]
@FilterId int = null
AS
SET NOCOUNT ON

DECLARE @AggregateClause varchar(max)
DECLARE @tblAggregateFilter TABLE (AggregateFilterClause varchar(max))
DECLARE @FilterClause varchar(max)
DECLARE @FilterType varchar(30)
DECLARE @TempEntityId int
DECLARE @ParentFilterId int

SELECT @FilterType = FilterType, @FilterClause= FilterClause, @TempEntityId=ParentFilterId FROM tblNegotiationFilters WHERE FilterId = @FilterId

if (@FilterType = ''stem'')
BEGIN  

   if @TempEntityId is null
    BEGIN
       SELECT @TempEntityId = EntityId FROM tblNegotiationFilters WHERE FilterId = @FilterId
    END

  INSERT INTO @tblAggregateFilter
	exec stp_NegotiationSiblingBaseFilterSelect @TempEntityId

  SELECT @AggregateClause = AggregateFilterClause from @tblAggregateFilter 
  
  if len(rtrim(ltrim(@AggregateClause))) > 0
  begin
	SET @FilterClause = @FilterClause + '' AND '' + @AggregateClause
  end
  
  UPDATE tblNegotiationFilters SET AggregateClause = @FilterClause, EntityId = @TempEntityId, ParentFilterId=null WHERE FilterId = @FilterId

END
else
BEGIN
 INSERT INTO  @tblAggregateFilter   
	  exec stp_NegotiationBaseFilterSelect @FilterId    

  SELECT @AggregateClause = AggregateFilterClause from @tblAggregateFilter 	
  UPDATE tblNegotiationFilters SET AggregateClause = @AggregateClause WHERE FilterId = @FilterId
END


' 
END
GO