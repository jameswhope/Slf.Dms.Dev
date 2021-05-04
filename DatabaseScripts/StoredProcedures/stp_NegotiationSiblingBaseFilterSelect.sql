IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationSiblingBaseFilterSelect')
	BEGIN
		DROP  Procedure  stp_NegotiationSiblingBaseFilterSelect
	END
	
BEGIN	
EXEC dbo.sp_executesql @statement = N'
/*
	Author: Bereket S. Data
	Description: Aggregates Baseline criteria for subsequent criteria creation within a specified entity
*/
CREATE PROCEDURE [dbo].[stp_NegotiationSiblingBaseFilterSelect]
@EntityId int,
@StemFilterId int = null
AS

SET NOCOUNT ON

DECLARE @FilterClause varchar(max)
DECLARE @AggregateClause varchar(max)
DECLARE @AggregateClauseAll varchar(max)
DECLARE @FilterId int
DECLARE @PrevLocalFilterId int
DECLARE @tblFilters TABLE (FilterId int,  FilterClause varchar(max), isRead int)

/***************   GETS ANCESTORS **********************/

SET @AggregateClauseAll = null
SET @FilterId = null

INSERT INTO @tblFilters
  SELECT FilterId, AggregateClause, 0 FROM tblNegotiationFilters 
  WHERE FilterId IN (SELECT FilterId FROM tblNegotiationFilterXref WHERE EntityId =  @EntityId AND Deleted = 0)
  AND Deleted = 0


SELECT TOP 1 @FilterId = FilterId, @AggregateClause= FilterClause FROM @tblFilters WHERE isRead = 0
WHILE @FilterId > 0
  BEGIN

    SET @PrevLocalFilterId = @FilterId
    if (@AggregateClauseAll is null)
    BEGIN        
		SET @AggregateClauseAll = @AggregateClause 
    END
    else
	BEGIN
		SET @AggregateClauseAll = @AggregateClauseAll + '' OR '' + @AggregateClause 
	END    
	UPDATE @tblFilters SET isRead = ''1'' WHERE FilterId = @FilterId
    SELECT TOP 1 @FilterId = FilterId, @AggregateClause= FilterClause FROM @tblFilters WHERE isRead = 0
    if (@FilterId =@PrevLocalFilterId)
	BEGIN
		SET @FilterId = 0
    END
  END

if not @StemFilterId is null
 BEGIN
  SELECT @FilterClause = FilterClause FROM tblNegotiationFilters WHERE FilterId = @StemFilterId
  SET @AggregateClauseAll = ''('' + @FilterClause + '') AND ('' + @AggregateClauseAll + '')''
 END

 SELECT @AggregateClauseAll as AggregateClause


'
END
GO



