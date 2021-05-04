
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationInitializeAssignment]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE stp_NegotiationInitializeAssignment
END
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
	Author: Bereket S. Data
	Description: Initialize/Update Criteria Status for usage
*/

CREATE PROCEDURE [dbo].[stp_NegotiationInitializeAssignment]
@FilterId int, 
@AuditType varchar(10),
@UserId int
AS

if (@AuditType = ''Added'')
  BEGIN
	INSERT INTO tblNegotiationFilterXref(FilterId,Created, CreatedBy,Deleted) VALUES ( @FilterId, getDate(),@UserId,''0'')
  END
else if (@AuditType = ''Updated'')
  BEGIN
	UPDATE tblNegotiationFilterXref  SET Modified=getDate(), ModifiedBy = @UserId WHERE FilterId = @FilterId
  END
else if (@AuditType = ''Deleted'')
  BEGIN
	UPDATE tblNegotiationFilterXref  SET Deleted = ''1'', ModifiedBy = @UserId WHERE FilterId = @FilterId
  END

' 
END
GO