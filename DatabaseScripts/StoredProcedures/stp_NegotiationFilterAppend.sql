
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationFilterAppend]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE stp_NegotiationFilterAppend
END
BEGIN
EXEC dbo.sp_executesql @statement = N'




/*
	Author: Bereket S. Data
	Description: Appends applicable filter clause for a specified criteria filter 
*/

CREATE PROCEDURE [dbo].[stp_NegotiationFilterAppend]
@FilterId int,
@Description varchar(150),
@FilterText varchar(max),
@FilterClause varchar(max)=null,
@UserId int = null

AS

UPDATE tblNegotiationFilters
SET
  filterClause = isnull(@filterClause,filterClause),
  --Description = Description + '' '' + @Description,  
  FilterText = FilterText + '' '' +  @FilterText,
  modified = getDate() 
  WHERE FilterId = @FilterId

exec stp_NegotiationFilterAggregateUpdate @FilterId

SELECT @FilterId

' 
END
GO
