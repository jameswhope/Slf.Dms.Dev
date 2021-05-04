SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationFilterDetailInsert]') AND type in (N'P', N'PC'))
BEGIN
DROP PROCEDURE stp_NegotiationFilterDetailInsert
END
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*
Author: Bereket S. Data
Description: Adds new criteria filter attributes. This is also mainly used by criteria builder.
*/

CREATE PROCEDURE [dbo].[stp_NegotiationFilterDetailInsert]
@FilterId int,
@FilterType varchar(10),
@sequence int,
@FieldName varchar(50),
@Operation varchar(15),
@OperationVisible varchar(6),
@FirstInput varchar(max),
@FirstInputVisible varchar(6),
@JoinClause varchar(10),
@JoinClauseVisible varchar(6),
@PctOf varchar(10),
@PctOfVisible varchar(6),
@PctField varchar(50),
@PctFieldVisible varchar(6)

AS

DECLARE @MaxFilterDetailId int
DECLARE @MatchSearch int

SET NOCOUNT ON

SELECT @MatchSearch = Count(FilterId)
FROM tblNegotiationFilterDetail
WHERE 
FieldName = @FieldName AND 
Operation = Operation AND
FirstInput = @FirstInput AND
PctOf = @PctOf AND
PctField= @PctField AND
FilterId = @FilterId

if @MatchSearch < = 0
BEGIN

 INSERT INTO tblNegotiationFilterDetail
 (
FilterId,
FilterType,
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
PctFieldVisible,
  Created
 )
 VALUES
 (
@FilterId,
@FilterType,
@sequence,
@FieldName,
@Operation,
@OperationVisible,
@FirstInput,
@FirstInputVisible,
@JoinClause,
@JoinClauseVisible,  
@PctOf,
@PctOfVisible,
@PctField,
@PctFieldVisible,
getDate() 
 )

DELETE tblNegotiationFilterDetail WHERE FieldName = ''0''
--UPDATE tblNegotiationFilterDetail SET JoinClause = ''and'' WHERE JoinClause = '''' AND FilterId = @FilterId
--SELECT @MaxFilterDetailId = max(FilterDetailId) 
--FROM tblNegotiationFilterDetail WHERE FilterId = @FilterId
--UPDATE tblNegotiationFilterDetail SET JoinClause = '''' WHERE FilterDetailId = @MaxFilterDetailId


END
' 
END
GO

