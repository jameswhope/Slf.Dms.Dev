/****** Object:  StoredProcedure [dbo].[get_CommRecAccountName]    Script Date: 11/19/2007 15:26:47 ******/
DROP PROCEDURE [dbo].[get_CommRecAccountName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[get_CommRecAccountName]
(
	@commRecId int
)

AS

BEGIN

SET NOCOUNT ON

SELECT
	Abbreviation
FROM
	tblCommRec
WHERE
	CommRecId=@commRecId
END
GO
