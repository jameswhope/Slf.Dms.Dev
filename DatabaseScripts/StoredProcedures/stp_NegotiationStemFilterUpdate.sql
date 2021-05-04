IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationStemFilterUpdate')
	BEGIN
		DROP  Procedure  stp_NegotiationStemFilterUpdate
	END

BEGIN


EXEC dbo.sp_executesql @statement = N'

/*
   Author: Bereket S. Data
   Description: Special handling for criteria with stem filter types. 
                This procedure update the aggregateclause for stem filters that belong to a given Entity.

*/

CREATE PROCEDURE [dbo].[stp_NegotiationStemFilterUpdate]
@FilterId int = null
AS
SET NOCOUNT ON

DECLARE @AggregateClause varchar(max)
DECLARE @tblAggregateFilter TABLE (AggregateFilterClause varchar(max))
DECLARE @FilterClause varchar(max)
DECLARE @StemFilterClause varchar(max)
DECLARE @FilterType varchar(30)
DECLARE @TempEntityId int
DECLARE @LocalFilterId int
DECLARE @PrevFilterId int
DECLARE @IdValue int 
DECLARE @tblStemFilter Table(FilterId int, ParentFilterId int, FilterClause varchar(max), isRead int)

SELECT @FilterType = FilterType, @TempEntityId = EntityId FROM tblNegotiationFilters WHERE FilterId = @FilterId
if (@FilterType = ''stem'')
 BEGIN  
  INSERT INTO @tblAggregateFilter
	exec stp_NegotiationSiblingBaseFilterSelect @TempEntityId

  SELECT @AggregateClause = AggregateFilterClause from @tblAggregateFilter 

  INSERT INTO @tblStemFilter
     SELECT FilterId, ParentFilterId,FilterClause, ''0'' FROM tblNegotiationFilters WHERE FilterType = ''stem'' and EntityId = @TempEntityId

  SELECT TOP 1 @LocalFilterId=FilterId, @FilterClause=FilterClause FROM @tblStemFilter WHERE isRead = 0
  WHILE not @LocalFilterId is null 
		BEGIN
             SET @PrevFilterId = @LocalFilterId
             exec @IdValue=stp_NegotiationStemClauseSelect @LocalFilterId
             If (@IdValue > 0)
                BEGIN
				    SELECT @StemFilterClause = FilterClause FROM tblNegotiationFilters WHERE FilterId = @IdValue
			        UPDATE tblNegotiationFilters SET AggregateClause = ''('' + (CASE WHEN len(rtrim(ltrim(@FilterClause))) > 0 THEN @FilterClause ELSE ''1=1'' END) + '') AND ('' + (CASE WHEN len(rtrim(ltrim(@StemFilterClause))) > 0 THEN @StemFilterClause ELSE ''1=1'' END) + '') AND ('' +  (CASE WHEN len(rtrim(ltrim(@AggregateClause))) > 0 THEN @AggregateClause ELSE ''1=1'' END) + '')'' WHERE EntityId = @TempEntityId AND FilterId = @LocalFilterId
			    END
              else
                BEGIN
				    UPDATE tblNegotiationFilters SET AggregateClause = ''('' + (CASE WHEN len(rtrim(ltrim(@FilterClause))) > 0 THEN @FilterClause ELSE ''1=1'' END) + '') AND ('' +  (CASE WHEN len(rtrim(ltrim(@AggregateClause))) > 0 THEN @AggregateClause ELSE ''1=1'' END) + '')'' WHERE EntityId = @TempEntityId AND FilterId = @LocalFilterId
                END

             SET @IdValue = 0
             SET @StemFilterClause = null

             UPDATE @tblStemFilter SET isRead = ''1'' WHERE FilterId = @LocalFilterId
			 SELECT TOP 1 @LocalFilterId=FilterId, @FilterClause=FilterClause FROM @tblStemFilter WHERE isRead = 0
             if (@PrevFilterId = @LocalFilterId)
             BEGIN
                SET @LocalFilterId = Null
             END
		END
 END

'
END

GO


