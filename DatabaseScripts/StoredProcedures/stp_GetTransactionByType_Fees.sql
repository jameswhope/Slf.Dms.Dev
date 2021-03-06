/****** Object:  StoredProcedure [dbo].[stp_GetTransactionByType_Fees]    Script Date: 11/19/2007 15:27:19 ******/
DROP PROCEDURE [dbo].[stp_GetTransactionByType_Fees]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_GetTransactionByType_Fees]
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
	tblEntryType.Fee=1 AND
	tblRegister.ClientId=@clientId and
	tblRegister.AdjustedRegisterID is null
ORDER BY
	tblRegister.TransactionDate ASC
GO
