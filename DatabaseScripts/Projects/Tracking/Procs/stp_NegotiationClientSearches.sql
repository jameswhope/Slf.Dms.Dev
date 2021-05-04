IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationClientSearches')
	BEGIN
		DROP  Procedure  stp_NegotiationClientSearches
	END

GO

CREATE procedure [dbo].[stp_NegotiationClientSearches]
	(
		@ids nvarchar(MAX) = null,
		@returntop varchar (50) = '100 percent',
		@where varchar (8000) = '',
		@orderby varchar (8000) = ''
	)

as

declare @vtblResults table
(
	ClientID int,
	[Type] varchar(500),
	[Name] varchar(500),
	AccountNumber varchar(500),
	SSN varchar(500),
	[Address] varchar(8000),
	ContactType varchar(8000),
	ContactNumber varchar(8000)
)

declare @vtblIDs table
(
	ClientID int
)

INSERT INTO
	@vtblResults
EXEC
(
	'SELECT TOP ' + @returntop + '
		ClientID,
		[Type],
		[Name],
		AccountNumber,
		SSN,
		[Address],
		ContactType,
		ContactNumber
	FROM
		tblClientSearch
	' + @where + ' ' + @orderby
)

if @ids is not null
begin
	declare @filterclause nvarchar(MAX)

	declare @fcTable table
	(
		FilterClause nvarchar(MAX)
	)

	INSERT INTO
		@fcTable
	EXEC
	(
		'declare @fc nvarchar(MAX)

		SELECT
			@fc = (CASE WHEN len(rtrim(ltrim(AggregateClause))) > 0 THEN coalesce(@fc + '' or '', '''') + ''('' + cast(AggregateClause as nvarchar(MAX)) + '')'' ELSE @fc END)
		FROM
			tblNegotiationFilters
		WHERE
			FilterID in (' + @ids + ')

		SELECT @fc'
	)

	SELECT TOP 1 @filterclause = FilterClause FROM @fcTable

	if @filterclause is null or len(@filterclause) = 0
	begin
		set @filterclause = '1 = 0'
	end

	INSERT INTO
		@vtblIDs
	EXEC 
	('
		SELECT
			DISTINCT ClientID
		FROM
			vwNegotiationDistributionSource
		WHERE
			' + @filterclause
	)

	DELETE @vtblResults WHERE ClientID not in (SELECT ClientID FROM @vtblIDs)
end


SELECT
	v.ClientID,
	cst.name as [ClientStatus],
	v.[Type],
	v.[Name],
	v.AccountNumber,
	SSN,
	[Address],
	ContactType,
	ContactNumber
FROM
	@vtblResults as v inner join tblclient as c on c.clientid=v.clientid inner join
	tblclientstatus as cst on c.currentclientstatusid=cst.clientstatusid 