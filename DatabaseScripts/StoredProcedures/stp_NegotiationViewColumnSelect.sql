
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationViewColumnSelect]') AND type in (N'P', N'PC'))
BEGIN
DROP PROCEDURE stp_NegotiationViewColumnSelect
END
BEGIN
EXEC dbo.sp_executesql @statement = N'







/*
 Author: Bereket S. Data
 Description: This stored Procedure returns Columns from Distribution view
*/

CREATE PROCEDURE [dbo].[stp_NegotiationViewColumnSelect]
@UseOrdinalPosition as bit = Null
AS
BEGIN
	declare @OrderByCol varchar(25)

	if @UseOrdinalPosition = 1
		BEGIN
			SELECT * 
			FROM INFORMATION_SCHEMA.COLUMNS 
			WHERE TABLE_NAME = ''vwNegotiationDistributionSource''
			ORDER BY ORDINAL_POSITION ASC
		END
	else
		BEGIN
			SELECT * 
			FROM INFORMATION_SCHEMA.COLUMNS 
			WHERE TABLE_NAME = ''vwNegotiationDistributionSource''
			ORDER BY COLUMN_NAME ASC
		END
END
' 
END

GO