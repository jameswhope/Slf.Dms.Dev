

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationPreviewMaster]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE stp_NegotiationPreviewMaster
END

BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
	Author: Bereket S. Data
	Description: Retrieves  top 10 accounts for the purpose of giving a user a birds-eye-view of accounts affected.
*/


CREATE PROCEDURE [dbo].[stp_NegotiationPreviewMaster]
@filterClause varchar(max),
@GridFilterId int 

AS
SET NOCOUNT ON

DECLARE @LocalfilterClause varchar(max)
DECLARE @FilterId int
DECLARE @OrFilter as varchar(max)
DECLARE @PreviousFilterId int
DECLARE @tblOrFilter TABLE (FilterId int,filterClause varchar(max), isRead int)
CREATE TABLE #tblAssignedList(AccountId int)

if @GridFilterId = 0
  BEGIN
   SET @GridFilterId = null
  END

SET @FilterId = null
SET @LocalfilterClause = null
SET @OrFilter = null

if not @GridFilterId is null
  BEGIN
   EXEC 
  (''
   SELECT DISTINCT TOP 10 ClientId, SSN, LTrim(ApplicantFullName) as ApplicantFullName ,ApplicantCity,ApplicantState,ApplicantZipCode,FundsAvailable,LeastDebtAmount
   FROM dbo.vwNegotiationDistributionSource
   WHERE 1=1 AND  ( '' + @filterClause + '' ) ORDER BY LTrim(ApplicantFullName) asc'' 
  )  
  END
else
  BEGIN
		  INSERT INTO @tblOrFilter
		   SELECT FilterId, filterClause, ''0'' FROM tblNegotiationFilters Where FilterType = ''root''
		   
		SELECT TOP 1 @LocalfilterClause = filterClause, @filterId = filterId FROM @tblOrFilter WHERE isRead = 0

		WHILE @filterId > 0
		 BEGIN
			SET @PreviousFilterId = @filterId    
			If not @OrFilter is null       
			   BEGIN
				  SET @OrFilter = @OrFilter + '' OR '' + ''('' + @LocalfilterClause + '')''
			   END
			else
			   BEGIN
				  SET @OrFilter =  ''( '' + @LocalfilterClause + '')''
			   END
			UPDATE @tblOrFilter SET isRead = 1 WHERE FilterId = @FilterId
			SELECT TOP 1 @LocalfilterClause = filterClause, @filterId = FilterId FROM @tblOrFilter WHERE isRead = 0
			if @PreviousFilterId = @filterId
			 BEGIN
			   SET @filterId = 0
			 END
		 END   
	   if not @OrFilter is null
	   BEGIN
		EXEC 
		(''
		  INSERT INTO #tblAssignedList       
		  SELECT AccountId 
		  FROM dbo.vwNegotiationDistributionSource
		  WHERE 1=1 AND  ( '' + @OrFilter + '' )''
		 )	
		END

	   EXEC 
	  (''
	   SELECT DISTINCT TOP 10 ClientId, SSN, LTrim(ApplicantFullName) as ApplicantFullName ,ApplicantCity,ApplicantState,ApplicantZipCode,FundsAvailable,LeastDebtAmount
	   FROM dbo.vwNegotiationDistributionSource
	   WHERE 1=1 AND  ( '' + @filterClause + '' ) AND
	   AccountId NOT IN (SELECT AccountId FROM #tblAssignedList) ORDER BY LTrim(ApplicantFullName) asc''	   
	  )    
 END

DROP TABLE #tblAssignedList



' 
END
GO