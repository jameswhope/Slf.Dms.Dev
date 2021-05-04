IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationStemClauseSelect')
	BEGIN
		DROP  Procedure  stp_NegotiationStemClauseSelect
	END

GO

CREATE PROCEDURE [dbo].[stp_NegotiationStemClauseSelect]
@FilterId int 

AS
SET NOCOUNT ON

DECLARE @filterClause varchar(max)
DECLARE @SubCriteriaId int
DECLARE @LocalParentFilterId int
DECLARE @ParentFilterId int
DECLARE @LocalFilterId int
DECLARE @tblFilterIdList TABLE (FilterId int, ParentFilterId int)

SET @LocalFilterId = null
SET @filterClause = null

SELECT @LocalFilterId=FilterId, @ParentFilterId = ParentFilterId, @filterClause = filterClause FROM tblNegotiationFilters WHERE FilterId = @FilterId and Filtertype = 'stem'
WHILE not @ParentFilterId  is null
  BEGIN
    SET @LocalParentFilterId = @ParentFilterId
    INSERT INTO @tblFilterIdList (FilterId,ParentFilterId) VALUES (@LocalFilterId, @ParentFilterId)
	SELECT @LocalFilterId=FilterId, @ParentFilterId = ParentFilterId, @filterClause = filterClause FROM tblNegotiationFilters WHERE FilterId = @ParentFilterId and Filtertype = 'stem'   
    if (@ParentFilterId is null)
       BEGIN
		INSERT INTO @tblFilterIdList (FilterId,ParentFilterId) VALUES (@LocalFilterId, @ParentFilterId)        
       END    
    else if (@LocalParentFilterId = @ParentFilterId)
       BEGIN
           SET @ParentFilterId =  null
       END
  END

 SELECT @SubCriteriaId = isnull(FilterId,0) FROM @tblFilterIdList WHERE ParentFilterid is Null

return @SubCriteriaId

GO