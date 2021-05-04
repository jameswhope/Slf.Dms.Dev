IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationEntityFilterSelect')
	BEGIN
		DROP  Procedure  stp_NegotiationEntityFilterSelect
	END

BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
	Author: Bereket S. Data
	Description: Retrives sub-criteria filters for a given entity
*/

CREATE PROCEDURE [dbo].[stp_NegotiationEntityFilterSelect]
@EntityId int,
@DisplayMode varchar (10) 
AS

if(@DisplayMode = ''base'')

BEGIN
 SELECT DISTINCT f.FilterId,f.Description, f.FilterClause, f.FilterText, f.FilterType, isnull(f1.ParentFilterId,f.FilterId) as ParentFilterId
 FROM tblNegotiationFilters f
 LEFT JOIN tblNegotiationFilters f1 ON f.FilterId = isnull(f1.ParentFilterId, f1.FilterId) 
 WHERE f.FilterId IN
 (
   SELECT FilterId 
   FROM tblNegotiationFilterXref 
   WHERE EntityId = @EntityId and Deleted = 0
 )
 ORDER BY f.[Description]
END
else
BEGIN
 SELECT DISTINCT f.FilterId,f.Description, f.FilterClause, f.FilterText, f.FilterType, isnull(f1.ParentFilterId,f.FilterId) as ParentFilterId
 FROM tblNegotiationFilters f
 LEFT JOIN tblNegotiationFilters f1 ON f.FilterId = isnull(f1.ParentFilterId, f1.FilterId) 
 WHERE f.EntityId = @EntityId AND f.FilterType = ''stem'' and f.ParentFilterId is null And f.GroupBy is null -- f.Deleted = ''0''
END

'
END
GO