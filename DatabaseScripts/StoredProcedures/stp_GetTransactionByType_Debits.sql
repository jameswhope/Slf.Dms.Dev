/****** Object:  StoredProcedure [dbo].[stp_GetTransactionByType_Debits]    Script Date: 11/19/2007 15:27:18 ******/
DROP PROCEDURE [dbo].[stp_GetTransactionByType_Debits]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_GetTransactionByType_Debits]
	(
		@clientId int
	)

as

SELECT
	tblRegister.*,
	tblEntryType.[Name] as EntryTypeName
FROM
	tblRegister INNER JOIN
	tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId
WHERE
	NOT tblEntryType.Fee=1 AND
	tblRegister.Amount < 0 AND
	tblRegister.ClientId=@clientId and
	tblRegister.AdjustedRegisterID is null
ORDER BY
	tblRegister.TransactionDate ASC
GO
