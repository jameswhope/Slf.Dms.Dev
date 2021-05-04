
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationFilterDetailCleanUp]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE stp_NegotiationFilterDetailCleanUp
END
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*
	Author: Bereket S. Data
	Description: Used to cleanup attributes when adding/updating filter details for a given criteria filter
*/

CREATE PROCEDURE [dbo].[stp_NegotiationFilterDetailCleanUp]
@FilterId int
AS

DECLARE @MaxFilterDetailId int

DELETE tblNegotiationFilterDetail WHERE FieldName = ''0'' AND FilterId = @FilterId
UPDATE tblNegotiationFilterDetail SET JoinClause = ''and'' WHERE JoinClause = '''' AND FilterId = @FilterId
SELECT @MaxFilterDetailId = max(FilterDetailId) 
FROM tblNegotiationFilterDetail WHERE FilterId = @FilterId
UPDATE tblNegotiationFilterDetail SET JoinClause = '''' WHERE FilterDetailId = @MaxFilterDetailId
' 
END
GO