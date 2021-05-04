IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CacheView')
	BEGIN
		DROP  Procedure  [stp_CacheView]
	END

GO

CREATE PROCEDURE [dbo].[stp_CacheView]
(
	@view nvarchar(250),
	@newTable nvarchar(250) = null
)

AS

declare @columns nvarchar(MAX)

if @newTable is null
begin
	set @newTable = 'tblCache_' + @view
end

if EXISTS(SELECT * FROM sys.tables WHERE [name] = @newTable)
begin
	exec ('TRUNCATE TABLE ' + @newTable)
end
else begin
	set @columns = 'CREATE TABLE ' + @newTable + ' ('

	SELECT
		@columns = @columns + '[' + c.name + '] ' + t.name + (CASE WHEN t.precision = 0 THEN '(' + cast(c.max_length as nvarchar(50)) + ')' ELSE '' END) + ' null,'
	FROM
		sys.columns as c
		inner join sys.objects as o on o.object_id = c.object_id
		inner join sys.types as t on t.system_type_id = c.system_type_id
	WHERE
		o.name = 'vwNegotiationDistributionSource'
	ORDER BY
		c.column_id

	set @columns = substring(@columns, 0, len(@columns)) + ', EntityID int)'

	exec(@columns)
end


exec
(
	'INSERT INTO
		' + @newTable + '
	SELECT
		*, null [EntityID]
	FROM
		' + @view
)