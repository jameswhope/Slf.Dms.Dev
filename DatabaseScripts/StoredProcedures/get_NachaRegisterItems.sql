/****** Object:  StoredProcedure [dbo].[get_NachaRegisterItems]    Script Date: 11/19/2007 15:26:48 ******/
DROP PROCEDURE [dbo].[get_NachaRegisterItems]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[get_NachaRegisterItems]
(
	@nachaFileId int,
	@CommRecID0 int,
	@CommRecID1 int,
	@CommRecID2 int,
	@CommRecID3 int
)

AS

BEGIN

SET NOCOUNT ON

SELECT
	nr.NachaRegisterId,
	nr.Name,
	nr.AccountNumber,
	nr.RoutingNumber,
	nr.Amount,
	nr.CommRecId,
	nr.IsPersonal,
	nr.[type] as AccountType
FROM
	tblNachaRegister nr
WHERE
	nr.NachaFileId = @nachaFileId
	and CommRecId in (@CommRecID0, @CommRecID1, @CommRecID2, @CommRecID3)

END
GO
