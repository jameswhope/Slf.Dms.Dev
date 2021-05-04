
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationFilterInsert]') AND type in (N'P', N'PC'))
BEGIN
DROP PROCEDURE stp_NegotiationFilterInsert
END

BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
 Author: Bereket S. Data>
 Description: Adds New Negotiation Criteria Filters
*/

CREATE PROCEDURE [dbo].[stp_NegotiationFilterInsert]
@FilterId int = null,
@FilterDescription varchar(600),
@FilterClause varchar(Max),
@FilterType varchar(10),
@FilterText varchar(Max),
@ParentFilterId int = null,
@UserId int = null
AS

DECLARE @AggregateClause varchar(max)
DECLARE @ScopIdentity int
DECLARE @tblAggregateFilter TABLE (AggregateFilterClause varchar(max))


if @ParentFilterId = 0
  BEGIN
	SET @ParentFilterId = null    
  END


BEGIN
 INSERT INTO tblNegotiationFilters
 (
	Description,
	FilterClause,
	FilterType,
	FilterText,
    ParentFilterId,    
	CreatedBy,
	Created
 )
 VALUES
 (
	@FilterDescription,
	@FilterClause,
	@FilterType,
	@FilterText,
    @ParentFilterId,    
	@UserId,
	getDate() 
 )


SELECT @ScopIdentity = SCOPE_IDENTITY() FROM tblNegotiationFilters

exec stp_NegotiationFilterAggregateUpdate @ScopIdentity
exec stp_NegotiationFilterAuditLog @ScopIdentity, @UserId, ''Added''
exec stp_NegotiationInitializeAssignment @ScopIdentity, ''Added'', @UserId

SELECT @ScopIdentity

END
' 
END
GO
