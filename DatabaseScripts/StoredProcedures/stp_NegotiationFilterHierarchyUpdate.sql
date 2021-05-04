SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationFilterHierarchyUpdate]') AND type in (N'P', N'PC'))
BEGIN
DROP PROCEDURE stp_NegotiationFilterHierarchyUpdate
END

BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
	Author: Bereket S. Data
	Descriptions: Update AggregateClause field for a given criteria filter

*/

CREATE PROCEDURE [dbo].[stp_NegotiationFilterHierarchyUpdate]
@FilterId int,
@UserId int,
@AggregateClause varchar(Max)

AS
SET NOCOUNT ON

DECLARE @filterClause varchar(Max)
DECLARE @AggClause varchar(Max)
DECLARE @Filtertype varchar(20)

SELECT @FilterType = FilterType FROM tblNegotiationFilters WHERE FilterId = @FilterId
if (@FilterType <> ''stem'')
/* 
--Commented out to avoid cascade update problem
if (@FilterType = ''stem'')
 BEGIN
		exec stp_NegotiationStemFilterUpdate @FilterId
 END
 
else
*/
 BEGIN
  SELECT @filterClause = FilterClause FROM tblNegotiationFilters WHERE FilterId = @FilterId
  
  if len(rtrim(ltrim(@filterClause))) > 0
  begin
	SET @AggClause = ''('' + @AggregateClause + '' ) AND ( '' + @filterClause + '')''
  end
  
  UPDATE tblNegotiationFilters 
  SET AggregateClause = @AggClause WHERE FilterId = @FilterId AND Deleted = ''0''
 END
 exec stp_NegotiationFilterAuditLog @FilterId, @UserId, ''Updated''


' 
END
GO
