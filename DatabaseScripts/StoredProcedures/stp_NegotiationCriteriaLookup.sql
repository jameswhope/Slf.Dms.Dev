IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationCriteriaLookup')
	BEGIN
		DROP  Procedure  stp_NegotiationCriteriaLookup
	END

GO

EXEC ('

/*
	Author: Bereket S. Data
	Description: Retrives account information based on a search criteria that is passed as a parameter.
	             NOTE: This stored procedure is mainly used by critier builder to give user that ability to
	                   search field values.
*/

CREATE PROCEDURE [dbo].[stp_NegotiationCriteriaLookup]
@ExecWhere varchar(Max),
@ExecField varchar(60)
AS

BEGIN
   EXEC (''SELECT DISTINCT rtrim(ltrim('' + @ExecField + '')) as [Description]  
          FROM dbo.vwNegotiationDistributionSource  
          WHERE '' +   @ExecWhere 
         )
END




')
GO