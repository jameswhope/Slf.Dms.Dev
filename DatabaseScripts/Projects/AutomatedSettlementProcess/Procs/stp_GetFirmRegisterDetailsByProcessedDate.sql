IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetFirmRegisterDetailsByProcessedDate')
	BEGIN
		DROP  Procedure  stp_GetFirmRegisterDetailsByProcessedDate
	END

GO

CREATE Procedure [dbo].[stp_GetFirmRegisterDetailsByProcessedDate]
(
	@FirmId int,
	@StartDate datetime,
	@EndDate datetime
)

AS
BEGIN

	IF @FirmId <> 3 BEGIN
		SELECT
			r.FirmRegisterId,
			r.RegisterId,
			isnull(r.FeeRegisterId, 0) AS FeeRegisterId,
			r.FirmId,
			r.ProcessedDate,
			r.RequestType,
			r.CheckNumber,			
			r.RecipientAccountNumber,
			r.RecipientName,
			r.DataType ,
			r.Amount AS AdjustedCheckAmount,
			r.Amount AS CheckAmount,
			isnull((SELECT Amount FROM tblRegister WHERE RegisterId = r.FeeRegisterId) * -1, 0) AS FeeAmount,
			isnull((SELECT Amount FROM tblRegister WHERE RegisterId = r.FeeRegisterId) * -1, 0) AS AdjustedFeeAmount,
			(r.Amount - isnull((SELECT Amount FROM tblRegister WHERE RegisterId = r.FeeRegisterId)* -1, 0) ) As SettlementAmount,
			(r.Amount - isnull((SELECT Amount FROM tblRegister WHERE RegisterId = r.FeeRegisterId)* -1, 0)) As AdjustedSettlementAmount,
			r.DataType AS AdjustedDataType,
			0 AS Counted,
			a.DeliveryMethod 
		FROM tblFirmRegister r 
		inner join tblAccount_PaymentProcessing a ON a.CheckNumber = r.CheckNumber and a.CheckAmount = r.Amount
		WHERE
			r.ProcessedDate between @StartDate and @EndDate and
			r.FirmId = @FirmId and r.Cleared = 0 and (r.Void = 0 or r.Void is null)		
	END
	ELSE BEGIN
		SELECT
			r.FirmRegisterId,
			r.RegisterId,
			isnull(r.FeeRegisterId, 0) AS FeeRegisterId,
			r.FirmId,
			r.ProcessedDate,
			r.RequestType,
			r.CheckNumber,			
			r.RecipientAccountNumber,
			r.RecipientName,
			r.DataType ,
			r.Amount AS AdjustedCheckAmount,
			r.Amount AS CheckAmount,
			isnull((SELECT Amount FROM tblRegister WHERE RegisterId = r.FeeRegisterId)* -1, 0)  AS FeeAmount,
			isnull((SELECT Amount FROM tblRegister WHERE RegisterId = r.FeeRegisterId)* -1, 0) AS AdjustedFeeAmount,
			(r.Amount - isnull((SELECT Amount FROM tblRegister WHERE RegisterId = r.FeeRegisterId)* -1, 0)) As SettlementAmount,
			(r.Amount - isnull((SELECT Amount FROM tblRegister WHERE RegisterId = r.FeeRegisterId)* -1, 0) ) As AdjustedSettlementAmount,
			r.DataType AS AdjustedDataType,
			0 AS Counted,
			a.DeliveryMethod
		FROM tblFirmRegister r 
		inner join tblAccount_PaymentProcessing a ON a.CheckNumber = r.CheckNumber and a.CheckAmount = r.Amount
		WHERE
			r.ProcessedDate between @StartDate and @EndDate and
			r.FirmId IN (3,4,5,6) and r.Cleared = 0 and (r.Void = 0 or r.Void is null)		
	END
END
GO


GRANT EXEC ON stp_GetFirmRegisterDetailsByProcessedDate TO PUBLIC

GO


