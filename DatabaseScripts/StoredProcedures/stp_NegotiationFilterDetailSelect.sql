
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationFilterDetailSelect]') AND type in (N'P', N'PC'))
BEGIN
DROP PROCEDURE stp_NegotiationFilterDetailSelect
END

BEGIN
EXEC dbo.sp_executesql @statement = N'
/*
	Author: Bereket S. Data
	Description: Retrieves Criteria Filter Details. This is mainly used by Criteria Builder
*/

CREATE PROCEDURE [dbo].[stp_NegotiationFilterDetailSelect]
@FilterId int
AS

 SELECT
FilterId,
sequence,
FieldName,
Operation,
OperationVisible,
FirstInput,
FirstInputVisible,
JoinClause,
joinClauseVisible,
PctOf,
PctOfVisible,
PctField,
PctFieldVisible
FROM  tblNegotiationFilterDetail 
WHERE FilterId = @FilterId 
' 
END
GO

