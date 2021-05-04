
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationChildFilterSelect]') AND type in (N'P', N'PC'))
BEGIN
DROP PROCEDURE stp_NegotiationChildFilterSelect

END
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
	Author: Bereket S. Data
	Description: Retrieves sub-criteria filter for a give master criteria filter
*/

CREATE PROCEDURE [dbo].[stp_NegotiationChildFilterSelect]
@ParentFilterId int,
@RetrieveToDelete int = 0  -- This flag is used to retrieve sibling based on action type to be performed.
AS

if @RetrieveToDelete = ''0''
BEGIN 
 SELECT f.FilterId,f.Description, f.FilterClause, f.FilterText,f.FilterType
 FROM tblNegotiationFilters f
 WHERE ParentFilterId = @ParentFilterId and FilterType = ''stem''
 ORDER BY f.[Description]
END
else
BEGIN 
 SELECT f.FilterId,f.Description, f.FilterClause, f.FilterText,f.FilterType
 FROM tblNegotiationFilters f
 WHERE ParentFilterId = @ParentFilterId
 ORDER BY f.[Description]
END
' 
END
GO
