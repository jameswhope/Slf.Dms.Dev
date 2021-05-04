--================================================
--  Create Inline Table-valued Function template
--	Author:		Jim Hope
--	Created:	05/08/2008
--	Name:		fnParseListToTable
--	Purpose:	Parses a delimited string to a 
--				variable table and returns that
--				table.
--	Usage:		SET @varTblXYZ = SELECT * FROM fnParseListToTable(@List, @Delimiter) 
--================================================
USE DMS_DEV
GO

IF OBJECT_ID (N'dbo.ParseListToTable') IS NOT NULL
    DROP FUNCTION dbo.ParseListToTable
GO

CREATE FUNCTION dbo.fnParseListToTable
(
	@AllItemsList VARCHAR(MAX), 
	@Delimeter CHAR(1),
	@NoFields CHAR(2)
)
RETURNS 
	@rtnTable TABLE
	(
		Item VARCHAR(4)
	)
AS
BEGIN
		DECLARE @strItem VARCHAR(4)
		DECLARE @StartPos INT
		DECLARE @Length INT

		WHILE LEN(@AllItemsList) > 0
			BEGIN
				SET @StartPos = CHARINDEX(@Delimeter, @AllItemsList)
				IF @StartPos < 0 SET @StartPos = 0
				SET @Length = LEN(@AllItemsList) - @StartPos - 1
				IF @Length < 0 SET @Length = 0
				IF @StartPos > 0
				  BEGIN
					SET @strItem = SUBSTRING(@AllItemsList, 1, @StartPos - 1)
					SET @AllItemsList = SUBSTRING(@AllItemsList, @StartPos + 1, LEN(@AllItemsList) - @StartPos)
				  END
				ELSE
				  BEGIN
					SET @strItem = @AllItemsList
					SET @AllItemsList = ''
				  END
				INSERT @rtnTable (Item) VALUES (@strItem)
			END
	RETURN
END
GO