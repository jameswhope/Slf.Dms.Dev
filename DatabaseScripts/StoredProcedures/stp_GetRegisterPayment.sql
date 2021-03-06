/****** Object:  StoredProcedure [dbo].[stp_GetRegisterPayment]    Script Date: 11/19/2007 15:27:14 ******/
DROP PROCEDURE [dbo].[stp_GetRegisterPayment]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[stp_GetRegisterPayment]
	(
		@registerPaymentId int
	)

as

SELECT 
	tblRegisterPayment.*, 
	tblRegisterPaymentDeposit.DepositRegisterId,
	tblRegisterPaymentDeposit.Amount as DepositAmountUsed, 
	tblDepositRegister.Amount as DepositAmount, 
	tblRegisterPaymentDeposit.Voided as DepositVoided, 
	tblRegisterPaymentDeposit.Bounced as DepositBounced,
	tblDepositRegister.TransactionDate as DepositDate,
	tblDepositRegister.CheckNumber as DepositCheckNumber,
	tblEntryType.[Name] as EntryTypeName,
	tblFeeRegister.Amount as FeeAmount
FROM 
	tblRegisterPayment INNER JOIN 
	tblRegisterPaymentDeposit ON tblRegisterPayment.RegisterPaymentId=tblRegisterPaymentDeposit.RegisterPaymentId INNER JOIN
	tblRegister tblFeeRegister ON tblRegisterPayment.FeeRegisterId = tblFeeRegister.RegisterId INNER JOIN
	tblRegister tblDepositRegister ON tblRegisterPaymentDeposit.DepositRegisterId=tblDepositRegister.RegisterId INNER JOIN
	tblEntryType ON tblFeeRegister.EntryTypeId=tblEntryType.EntryTypeId
WHERE 
	tblRegisterPayment.RegisterPaymentID = @registerPaymentId
GO
