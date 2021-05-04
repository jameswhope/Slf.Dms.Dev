IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationDashboardGetByID')
	BEGIN
		DROP  Procedure  [stp_NegotiationDashboardGetByID]
	END
	
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

CREATE PROCEDURE [dbo].[stp_NegotiationDashboardGetByID]
(
	@filterid int,
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

declare @filterclause varchar(MAX)

set @filterclause = null


if @filterid is not null
begin
	SELECT
		@filterclause = AggregateClause
	FROM
		tblNegotiationFilters
	WHERE
		FilterID = @filterid
end

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
