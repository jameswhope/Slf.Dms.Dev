/****** Object:  StoredProcedure [dbo].[insert_NachaFile]    Script Date: 11/19/2007 15:26:49 ******/
DROP PROCEDURE [dbo].[insert_NachaFile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insert_NachaFile]
(
	@date datetime,
	@effectiveDate datetime
)

AS

BEGIN

SET NOCOUNT ON

INSERT INTO tblNachaFile
(
	Date,
	EffectiveDate
)
VALUES
(
	@date,
	@effectiveDate
)

SELECT CAST(SCOPE_IDENTITY() AS int) AS NachaFileId

END
GO
