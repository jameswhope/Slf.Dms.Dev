IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationDashboardGet')
	BEGIN
		DROP  Procedure  [stp_NegotiationDashboardGet]
	END
	
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

CREATE PROCEDURE [dbo].[stp_NegotiationDashboardGet]
(
	@ids nvarchar(100),
	@query nvarchar(MAX) = null,
	@orderby nvarchar(500) = null,
	@groupby nvarchar(500) = null
)

AS

if @query is null
begin
	set @query = '*'
end

if @groupby is null
begin
	set @groupby = ''
end
else
begin
	set @groupby = 'GROUP BY ' + @groupby
end

if @orderby is null
begin
	set @orderby = ''
end
else
begin
	set @orderby = 'ORDER BY ' + @orderby
end

declare @filterclause nvarchar(MAX)

declare @fcTable table
(
	FilterClause nvarchar(MAX)
)

INSERT INTO
	@fcTable
exec
('
declare @fc nvarchar(MAX)

SELECT
	@fc = (CASE WHEN len(rtrim(ltrim(AggregateClause))) > 0 THEN coalesce(@fc + '' or '', '''') + ''('' + cast(AggregateClause as nvarchar(MAX)) + '')'' ELSE @fc END)
FROM
	tblNegotiationFilters
WHERE
	FilterID in (' + @ids + ')

SELECT @fc
')

SELECT TOP 1 @filterclause = FilterClause FROM @fcTable

if @filterclause is null or len(@filterclause) = 0
begin
	set @filterclause = '1 = 0'
end

EXEC 
('
	SELECT
		' + @query + '
	FROM
		tblCache_vwNegotiationDistributionSource
	WHERE
		' + @filterclause + '
	' + @groupby + '
	' + @orderby
)