SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_NegotiationFilterDetailDelete]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE stp_NegotiationFilterDetailDelete 
END
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*
	Author: Bereket S. Data>
	Description: Removed  attributes for a specified criteria filter
*/


CREATE PROCEDURE [dbo].[stp_NegotiationFilterDetailDelete]
@FilterId int
AS
SET NOCOUNT ON

BEGIN
 DELETE tblNegotiationFilterDetail 
 WHERE FilterId = @FilterId  
END
' 
END
GO

