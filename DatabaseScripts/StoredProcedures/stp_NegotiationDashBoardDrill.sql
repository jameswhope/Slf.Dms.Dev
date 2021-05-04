
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationDashBoardDrill]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE stp_NegotiationDashBoardDrill
END
GO

BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
	Author: Bereket S. Data
	Description: Retrieves drilldown summary for a specified field request

*/

CREATE PROCEDURE [dbo].[stp_NegotiationDashBoardDrill]
@FilterId int,
@DrillType varchar(50)

AS
SET NOCOUNT ON

DECLARE @filterClause varchar(max)

SELECT @filterClause = AggregateClause FROM tblNegotiationFilters WHERE FilterId = @FilterId


if @DrillType = ''AccountType''
 BEGIN
 EXEC 
  (''
   SELECT AccountStatus as Description, Count(AccountId) as Count
   FROM dbo.vwNegotiationDistributionSource
   WHERE 1=1 AND  ( '' + @filterClause + '' )
   GROUP BY   AccountStatus 
   ORDER BY AccountStatus ''
  )     
 END

else if @DrillType = ''States''
 BEGIN
 EXEC 
  (''
   SELECT ApplicantState as Description, Count(AccountId) as Count
   FROM dbo.vwNegotiationDistributionSource
   WHERE 1=1 AND  ( '' + @filterClause + '' )
   GROUP BY   ApplicantState
   ORDER BY  ApplicantState''
  )     
 END

else if @DrillType = ''Creditors''
 BEGIN
 EXEC 
  (''
   SELECT rtrim(ltrim(CurrentCreditor)) as Description, Count(AccountId) as Count
   FROM dbo.vwNegotiationDistributionSource
   WHERE 1=1 AND  ( '' + @filterClause + '' )
   GROUP BY   rtrim(ltrim(CurrentCreditor)) 
   ORDER BY rtrim(ltrim(CurrentCreditor))''
  )     
 END
' 
END
GO

