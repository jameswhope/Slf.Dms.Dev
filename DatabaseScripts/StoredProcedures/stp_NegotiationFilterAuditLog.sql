
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationFilterAuditLog]') AND type in (N'P', N'PC'))
BEGIN
 DROP PROCEDURE stp_NegotiationFilterAuditLog
END
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
	Author: Bereket S. Data
	Description: Adds (add/update/delete) activities made to criteria filters.
*/

CREATE PROCEDURE [dbo].[stp_NegotiationFilterAuditLog]
@FilterId int = null,
@UserId int,
@AuditType varchar(10)
AS

DECLARE @MatchCount int
DECLARE @tblAuditLog TABLE 
(
FilterId int,
FilterType varchar(50),
FilterClause varchar(max),
FilterText varchar(max),
AggregateClause varchar(max),
AuditType varchar(15)
)

INSERT INTO @tblAuditLog
  SELECT TOP 1 FilterId,FilterType,FilterClause,FilterText,AggregateClause, AuditType
  FROM tblNegotiationFilterAudit ORDER BY AuditDate Desc


SELECT @MatchCount = Count(l.FilterId) 
FROM tblNegotiationFilters f
INNER JOIN @tblAuditLog l ON l.FilterId = f.FilterId
WHERE
l.FilterType = f.FilterType AND
l.FilterClause = f.FilterClause AND
l.FilterText = f.FilterText AND
l.AggregateClause = f.AggregateClause AND
l.AuditType = @AuditType AND
f.FilterId = @FilterId



if @MatchCount = 0 
BEGIN  
 INSERT INTO tblNegotiationFilterAudit
   SELECT @FilterId, FilterType, FilterClause,FilterText,AggregateClause,@AuditType, getDate(), @UserId
   FROM tblNegotiationFilters WHERE FilterId = @FilterId
END
' 
END
GO

