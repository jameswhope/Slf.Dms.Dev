SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationFilterDelete]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE stp_NegotiationFilterDelete
END
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
 Author: Bereket S. Data>
 Description: Remove a given Criteria Filter
*/

CREATE PROCEDURE [dbo].[stp_NegotiationFilterDelete]
@FilterId int = null,
@UserId int = null
AS
SET NOCOUNT ON
DECLARE @FilterCount int

SELECT @FilterCount = Count(FilterId) FROM tblNegotiationFilters WHERE FilterId = @FilterId

if @FilterCount > 0
 BEGIN
	if not @FilterId is null
	 BEGIN

	   exec stp_NegotiationInitializeAssignment @FilterId, ''Deleted'', @UserId
	   exec stp_NegotiationFilterAuditLog @FilterId, @UserId, ''Deleted''
	   DELETE tblNegotiationFilters  WHERE FilterId = @FilterId 	   
	   UPDATE tblNegotiationFilterXref SET Deleted = ''1'', Modified=getDate(), ModifiedBy=@UserID WHERE FilterId = @FilterId
	 END
	else
	 BEGIN   
	   DELETE tblNegotiationFilters  
	   DELETE tblNegotiationFilterDetail 
	   DELETE tblNegotiationFilterXref 
	 END
  END


' 
END
GO


