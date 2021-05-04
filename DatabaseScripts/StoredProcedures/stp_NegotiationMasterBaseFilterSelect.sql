
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationMasterBaseFilterSelect]') AND type in (N'P', N'PC'))
BEGIN
 DROP PROCEDURE stp_NegotiationMasterBaseFilterSelect
END
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*
	Author: Bereket S. Data
	Description: Aggregates Baseline criteria for subsequent criteria creation.
*/

CREATE PROCEDURE [dbo].[stp_NegotiationMasterBaseFilterSelect]
@FilterId int,
@FilterType varchar(25)
AS

SET NOCOUNT ON

DECLARE @PrevLocalFilterId int
DECLARE @LocalFilterId int
DECLARE @LocalFilterType varchar(25)
DECLARE @FilterClause varchar(max)
DECLARE @FilterDescription varchar(250)
DECLARE @FilterText varchar(max)
DECLARE @AndFilter varchar(max)
DECLARE @tblFilterIdList TABLE (FilterId int, FilterType varchar(25))
DECLARE @tblFilters TABLE (FilterId int,  FilterClause varchar(max), isRead int)

/***************   GETS ANCESTORS **********************/

SET @LocalFilterId = null

SELECT @LocalFilterId = ParentFilterId,@LocalFilterType = FilterType FROM tblNegotiationFilters WHERE FilterId = @FilterId
INSERT INTO @tblFilterIdList (FilterId,FilterType) VALUES (@FilterId,@FilterType)
WHILE not @LocalFilterId is null
  BEGIN
    SET @PrevLocalFilterId = @LocalFilterId
	INSERT INTO @tblFilterIdList (FilterId,FilterType) VALUES (@LocalFilterId,@LocalFilterType)
	SELECT @LocalFilterId = ParentFilterId, @LocalFilterType = FilterType FROM tblNegotiationFilters WHERE FilterId = @LocalFilterId   
	if (@LocalFilterId is null)
    BEGIN
        UPDATE @tblFilterIdList SET FilterType = ''root'' WHERE FilterId = @PrevLocalFilterId		
    END
  END


SELECT @AndFilter = f.filterClause, @FilterDescription=[Description], @FilterText=FilterText
FROM  @tblFilterIdList l 
INNER JOIN tblNegotiationFilters f ON f.filterId = l.filterId  
WHERE l.FilterType = ''root''
ORDER BY f.FilterId

SELECT @FilterClause = FilterClause 
FROM tblNegotiationFilters 
WHERE FilterId = @FilterId

If ((not @AndFilter is null) and (@AndFilter != @FilterClause))
 BEGIN
    UPDATE tblNegotiationFilters SET [Description] = @FilterDescription, FilterText = @FilterText
    WHERE Deleted = ''0'' AND FilterId In (SELECT FilterId FROM @tblFilterIdList WHERE FilterType not In (''root''))

	SELECT  ''(('' + @FilterClause + '') ''  + '' AND  ( '' + @AndFilter + '' ))''   as ''AndFilter''
 END
else if ( @AndFilter = @FilterClause)
 BEGIN
	SELECT  ''('' + @FilterClause + '') '' as ''AndFilter''
 END
' 
END
GO

