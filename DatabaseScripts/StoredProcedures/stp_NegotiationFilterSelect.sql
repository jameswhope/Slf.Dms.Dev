
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationFilterSelect]') AND type in (N'P', N'PC'))
BEGIN
DROP PROCEDURE stp_NegotiationFilterSelect
END
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
	Author: Bereket S. Data>
	Description: Retrieves existing Negotiation Criteria Filters
*/

CREATE PROCEDURE [dbo].[stp_NegotiationFilterSelect]
@FilterId int = null,
@FilterType varchar(10)= null
AS

if @FilterId = 0
BEGIN
SET @FilterId = NULL
END

if @FilterType = ''''
BEGIN
SET @FilterType = NULL
END

BEGIN
 SELECT DISTINCT f.FilterId,f.Description, f.FilterClause, f.FilterText, f.FilterType, isnull(f1.ParentFilterId,f.FilterId) as ParentFilterId
 FROM tblNegotiationFilters f
 LEFT JOIN tblNegotiationFilters f1 ON f.FilterId = isnull(f1.ParentFilterId, f1.FilterId)
 WHERE f.FilterId = isnull(@FilterId,f.FilterId)  
 AND f.FilterType = isnull(@FilterType, f.FilterType) 
 ORDER BY f.[Description]
END

' 
END
GO

