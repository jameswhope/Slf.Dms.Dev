
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationPreviewDrill]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE stp_NegotiationPreviewDrill
END

BEGIN

EXEC(
'
/*
	Author: Bereket S. Data
	Description: Retrieves a drilldown account informtaion for a given a client
*/
CREATE PROCEDURE [dbo].[stp_NegotiationPreviewDrill]
@ClientId int,
@FilterId int
AS

DECLARE @FilterClause varchar(max)

SELECT @FilterClause = AggregateClause FROM tblNegotiationFilters WHERE FilterId = @FilterId

EXEC
(''
SELECT AccountId, CurrentCreditorAccountNumber, OriginalCreditor,CurrentCreditor,CurrentCreditorState,CurrentAmount,AccountStatus, AccountAge
FROM dbo.vwNegotiationDistributionSource
WHERE ClientId = '' + @ClientId + '' AND '' +  @FilterClause + ''
ORDER BY CurrentCreditor ''
)
')
END
