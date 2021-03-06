/****** Object:  StoredProcedure [dbo].[get_OutstandingNachaRegisterItems]    Script Date: 11/19/2007 15:26:48 ******/
DROP PROCEDURE [dbo].[get_OutstandingNachaRegisterItems]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[get_OutstandingNachaRegisterItems]
(
	@CommRecID0 int,
	@CommRecID1 int,
	@CommRecID2 int,
	@CommRecID3 int
)

AS

BEGIN

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
	nr.NachaFileId IS NULL
	and CommRecId in (@CommrecID0, @CommrecID1, @CommrecID2, @CommrecID3)

END
GO
