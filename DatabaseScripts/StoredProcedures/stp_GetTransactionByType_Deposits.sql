IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetTransactionByType_Deposits')
	BEGIN
		DROP  Procedure  stp_GetTransactionByType_Deposits
	END


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

CREATE procedure [dbo].[stp_GetTransactionByType_Deposits]
	(
		@clientid int
	)

as

SELECT
	*
FROM
	tblRegister 
WHERE
	tblRegister.EntryTypeId = 3 and
	tblRegister.ClientId = @clientId and
	tblregister.AdjustedRegisterID is null
ORDER BY
	tblRegister.TransactionDate ASC