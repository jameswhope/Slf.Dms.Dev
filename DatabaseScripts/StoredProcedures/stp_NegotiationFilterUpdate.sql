SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationFilterUpdate]') AND type in (N'P', N'PC'))
BEGIN
DROP PROCEDURE stp_NegotiationFilterUpdate
END

BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
	Author: Bereket S. Data
	Description: Update Negotiation Criteria Filters
*/

CREATE PROCEDURE [dbo].[stp_NegotiationFilterUpdate]
@FilterId int,
@FilterType varchar(10)= null,
@FilterDescription varchar(600)=null,
@FilterText varchar(max)=null,
@FilterClause varchar(max)=null,
@ParentFilterId int = null,
@UserId int = null

AS

UPDATE tblNegotiationFilters
SET
  Description = isnull(@FilterDescription,Description),
  filterClause = isnull(@filterClause,filterClause),  
  ModifiedBy = isnull(@UserId,ModifiedBy),
  FilterType = isnull(@FilterType,FilterType),
  FilterText = isnull(@FilterText,FilterText),
  modified = getDate() 
  WHERE FilterId = @FilterId

exec stp_NegotiationFilterAggregateUpdate @FilterId
exec stp_NegotiationFilterAuditLog @FilterId, @UserId, ''Updated''
exec stp_NegotiationInitializeAssignment @FilterId, ''Updated'', @UserId


SELECT @FilterId
' 
END
GO
