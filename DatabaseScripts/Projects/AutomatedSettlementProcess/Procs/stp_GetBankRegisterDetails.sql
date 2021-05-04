IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetBankRegisterDetails')
	BEGIN
		DROP  Procedure  stp_GetBankRegisterDetails
	END

GO

CREATE Procedure [dbo].[stp_GetBankRegisterDetails]
(
	@AccountName varchar(50)
)

AS
BEGIN
	SELECT
		br.BankRegisterId,
		br.BankUploadId,
		br.ProcessedDate,
		br.Rejected,
		br.BAICode,
		br.Description,
		br.Amount,
		bp.BankAccountName,
		br.DataType ,
		br.CustomerRef,
		0 AS Counted
	FROM tblBankReconciliationInfo br inner join
		 tblBankUpload bp ON bp.BankUploadId = br.BankUploadId and bp.Processed = 0 and bp.BankAccountName = @AccountName
	WHERE
		br.Reconciled = 0 
END

GO

GRANT EXEC ON stp_GetBankRegisterDetails TO PUBLIC

GO

