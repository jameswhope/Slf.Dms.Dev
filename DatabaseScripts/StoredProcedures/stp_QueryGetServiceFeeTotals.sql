/****** Object:  StoredProcedure [dbo].[stp_QueryGetServiceFeeTotals]    Script Date: 11/19/2007 15:27:36 ******/
DROP PROCEDURE [dbo].[stp_QueryGetServiceFeeTotals]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_QueryGetServiceFeeTotals]
	(
		@CommRecId int,
		@CommScenIds varchar(255),
		@date1 datetime=null,
		@date2 datetime=null,
		@where varchar(8000) = '',
		@orderby varchar (8000) = '',
		@period varchar (100) = ''
	)

as

if @date1 is null 
	set @date1 = convert(datetime,'1800.01.01')
if @date2 is null 
	set @date2 = convert(datetime,'9999.01.01')

declare @CompanyName varchar(50)
set @CompanyName = (SELECT [Display] FROM tblCommRec WHERE CommRecId=@CommRecId)

create table #result
(
	NewChargesTotal money,
	FeePaymentsTotal money,

	PreviousCharges money,
	PreviousPayments money,
	PreviousBalance money,

	EndingBalance money
)

exec('
INSERT INTO	#result 
	(NewChargesTotal,
	FeePaymentsTotal,
	PreviousCharges,
	PreviousPayments)
SELECT
	(SELECT
		ISNULL(SUM(tblCommFeeCharge.FixedAmount), 0) 
	FROM 
		tblRegister INNER JOIN 
		tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId INNER JOIN
		tblClient ON tblRegister.ClientId=tblClient.ClientId INNER JOIN
		tblCommFeeCharge ON tblRegister.EntryTypeId=tblCommFeeCharge.EntryTypeId 
		AND tblCommFeeCharge.CommRecId=' + @CommRecId + '
	WHERE
		( CAST(CONVERT(char(10), tblRegister.TransactionDate, 101) AS datetime) >= ''' + @date1 + ''' ) AND
		( CAST(CONVERT(char(10), tblRegister.TransactionDate, 101) AS datetime) <= ''' + @date2 + ''' ) AND
		AgencyId in (SELECT AgencyId FROM tblCommScen WHERE CommScenId 
			IN (' + @CommScenIds + ')) ' + @where + '
	) as NewChargesTotal,
	

	((SELECT 
		ISNULL(SUM(tblCommPay.Amount), 0)
	FROM 
		tblCommBatch INNER JOIN
		tblCommPay on tblCommBatch.CommBatchId=tblCommPay.CommBatchId INNER JOIN 
		tblRegisterPayment on tblCommPay.RegisterPaymentId=tblRegisterPayment.RegisterPaymentId INNER JOIN
		tblRegister ON tblRegisterPayment.FeeRegisterId = tblRegister.RegisterId INNER JOIN
		tblCommStruct ON tblCommPay.CommStructId=tblCommStruct.CommStructId  INNER JOIN
		tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId
	WHERE
		( CAST(CONVERT(char(10), tblCommBatch.BatchDate, 101) AS datetime) >= ''' + @date1 + ''' ) AND
		( CAST(CONVERT(char(10), tblCommBatch.BatchDate, 101) AS datetime) <= ''' + @date2 + ''' ) AND
		tblCommStruct.CommScenId in (' + @CommScenIds + ') AND
		tblCommStruct.CommRecId=' + @CommRecId + 
		' ' + @where + ')
	-	

	(SELECT 
		ISNULL(SUM(tblCommPay.Amount), 0)
	FROM 
		tblCommBatch INNER JOIN
		tblCommChargeBack tblCommPay ON tblCommBatch.CommBatchId=tblCommPay.CommBatchId INNER JOIN 
		tblRegisterPayment on tblCommPay.RegisterPaymentId=tblRegisterPayment.RegisterPaymentId INNER JOIN
		tblRegister ON tblRegisterPayment.FeeRegisterId = tblRegister.RegisterId INNER JOIN
		tblCommStruct ON tblCommPay.CommStructId=tblCommStruct.CommStructId  INNER JOIN
		tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId
	WHERE
		( CAST(CONVERT(char(10), tblCommBatch.BatchDate, 101) AS datetime) >= ''' + @date1 + ''' ) AND
		( CAST(CONVERT(char(10), tblCommBatch.BatchDate, 101) AS datetime) <= ''' + @date2 + ''' ) AND
		tblCommStruct.CommScenId in (' + @CommScenIds + ') AND
		tblCommStruct.CommRecId=' + @CommRecId + 
		' ' + @where + '
	)) as FeePaymentsTotal,

	(SELECT
		ISNULL(SUM(tblCommFeeCharge.FixedAmount), 0) 
	FROM 
		tblRegister INNER JOIN 
		tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId INNER JOIN
		tblClient ON tblRegister.ClientId=tblClient.ClientId INNER JOIN
		tblCommFeeCharge ON tblRegister.EntryTypeId=tblCommFeeCharge.EntryTypeId 
		AND tblCommFeeCharge.CommRecId=' + @CommRecId + '
	WHERE
		( CAST(CONVERT(char(10), tblRegister.TransactionDate, 101) AS datetime) < ''' + @date1 + ''' ) AND
		AgencyId in (SELECT AgencyId FROM tblCommScen WHERE CommScenId 
			IN (' + @CommScenIds + ')) ' + @where + '
	) as PreviousCharges,
	

	((SELECT 
		ISNULL(SUM(tblCommPay.Amount), 0)
	FROM 
		tblCommBatch INNER JOIN
		tblCommPay ON tblCOmmBatch.CommBatchId=tblCommPay.CommBatchId INNER JOIN 
		tblRegisterPayment on tblCommPay.RegisterPaymentId=tblRegisterPayment.RegisterPaymentId INNER JOIN
		tblRegister ON tblRegisterPayment.FeeRegisterId = tblRegister.RegisterId INNER JOIN
		tblCommStruct ON tblCommPay.CommStructId=tblCommStruct.CommStructId  INNER JOIN
		tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId
	WHERE
		( CAST(CONVERT(char(10), tblCommBatch.BatchDate, 101) AS datetime) < ''' + @date1 + ''' ) AND
		tblCommStruct.CommScenId in (' + @CommScenIds + ') AND
		tblCommStruct.CommRecId=' + @CommRecId + 
		' ' + @where + ')
	-	

	(SELECT 
		ISNULL(SUM(tblCommPay.Amount), 0)
	FROM 
		tblCommBatch INNER JOIN
		tblCommChargeBack tblCommPay on tblCommBatch.CommbatchId=tblCommPay.COmMBatchId INNER JOIN 
		tblRegisterPayment on tblCommPay.RegisterPaymentId=tblRegisterPayment.RegisterPaymentId INNER JOIN
		tblRegister ON tblRegisterPayment.FeeRegisterId = tblRegister.RegisterId INNER JOIN
		tblCommStruct ON tblCommPay.CommStructId=tblCommStruct.CommStructId  INNER JOIN
		tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId
	WHERE
		( CAST(CONVERT(char(10), tblCommBatch.BatchDate, 101) AS datetime) < ''' + @date1 + ''' ) AND
		tblCommStruct.CommScenId in (' + @CommScenIds + ') AND
		tblCommStruct.CommRecId=' + @CommRecId + 
		' ' + @where + ')
	) as PreviousPayments
')

UPDATE 
	#result
SET
	PreviousBalance=PreviousCharges-PreviousPayments

UPDATE 
	#result 
SET
	EndingBalance=PreviousBalance+NewChargesTotal-FeePaymentsTotal

SELECT 
	@CompanyName as CompanyName,
	@Period as Period,
	#result.*
FROM
	#result

DROP TABLE #result
GO
