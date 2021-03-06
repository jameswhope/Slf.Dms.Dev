/****** Object:  StoredProcedure [dbo].[get_ClientACHInfo]    Script Date: 11/19/2007 15:26:47 ******/
DROP PROCEDURE [dbo].[get_ClientACHInfo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[get_ClientACHInfo]
(
	@clientId int
)

AS

SET NOCOUNT ON

SELECT
	DepositMethod,
	DepositDay,
	BankName,
	BankRoutingNumber,
	BankAccountNumber,
	BankType,
	DepositStartDate,
	DepositAmount
FROM
	tblClient
WHERE
	ClientId=@clientId
GO
