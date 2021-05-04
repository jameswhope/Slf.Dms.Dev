
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationDashboardGetFilterID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stp_NegotiationDashboardGetFilterID]
(
	@id nvarchar(50),
	@type nvarchar(50)
)

AS

declare @filterid int

declare @vtblFilter table
(
	FilterID int
)

INSERT INTO
	@vtblFilter
EXEC 
(''
	SELECT
		FilterID
	FROM
		tblNegotiationFilterXRef
	WHERE
		['' + @type + ''] = '' + @id
)

SELECT TOP 1
	@filterid = FilterID
FROM
	@vtblFilter

RETURN @filterid
' 
END
GO