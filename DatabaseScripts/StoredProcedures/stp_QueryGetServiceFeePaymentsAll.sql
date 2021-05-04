/****** Object:  StoredProcedure [dbo].[stp_QueryGetServiceFeePaymentsAll]    Script Date: 11/19/2007 15:27:35 ******/
DROP PROCEDURE [dbo].[stp_QueryGetServiceFeePaymentsAll]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_QueryGetServiceFeePaymentsAll]
	(
		@date1 datetime=null,
		@date2 datetime=null,
		@where varchar (8000) = '',
		@orderby varchar (8000) = '',
		@period varchar (100) = ''
	)

as

if @date1 is null 
	set @date1 = convert(datetime,'1800.01.01')
if @date2 is null 
	set @date2 = convert(datetime,'9999.01.01')

if not @orderby is null and not @orderby=''
	set @orderby=@orderby+' , ' 

exec('
SELECT 
	tblCommStruct.CommRecId,
	tblagency.agencyid,
	tblCommStruct.CommScenId,
	tblCommRec.Abbreviation as CommRecipName,
	tblCommPay.CommPayId,
	tblClient.AccountNumber,
	(SELECT Top 1 Created FROM tblRoadmap WHERE ClientId=tblClient.ClientId AND ClientStatusId=5) as HireDate,
	tblAgency.Name as CompanyName,
	tblPrimaryPerson.FirstName,
	tblPrimaryPerson.LastName,
	tblEntryType.[Name] as FeeCategory,
	''' + @period + ''' as Period,
	'''' as SettlementNumber, 
	-tblRegister.Amount as OriginalBalance,

	-(	tblRegister.Amount +
		(SELECT 
			case when SUM(b.Amount) is null then 0 else sum(b.amount) end
		FROM 
			tblRegisterPayment b
		WHERE 
			b.FeeRegisterId=tblRegisterPayment.FeeRegisterId AND 
			b.RegisterPaymentId<tblRegisterPayment.RegisterPaymentId)
	) as BeginningBalance,
	(-(	tblRegister.Amount +
		(SELECT 
			case when SUM(b.Amount) is null then 0 else sum(b.amount) end
		FROM 
			tblRegisterPayment b
		WHERE 
			b.FeeRegisterId=tblRegisterPayment.FeeRegisterId AND 
			b.RegisterPaymentId<tblRegisterPayment.RegisterPaymentId)
	)- tblRegisterPayment.Amount ) as EndingBalance,

	tblRegisterPayment.Amount as PaymentAmount,
	tblRegisterPayment.PaymentDate,

	tblCommPay.[Percent] as Rate,
	tblCommPay.Amount

FROM 
	tblCommBatch INNER JOIN 
	tblCommPay ON tblCommBatch.CommBatchId=tblCommPay.CommBatchId INNER JOIN
	tblRegisterPayment ON tblCommPay.RegisterPaymentId=tblRegisterPayment.RegisterPaymentId INNER JOIN
	tblCommStruct ON tblCommPay.CommStructId=tblCommStruct.CommStructId INNER JOIN
	tblCommScen ON tblCommStruct.CommScenId=tblCommScen.CommScenId INNER JOIN	
	tblRegister ON tblRegisterPayment.FeeRegisterId = tblRegister.RegisterId INNER JOIN
	tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId INNER JOIN
	tblClient ON tblRegister.ClientId=tblClient.ClientId INNER JOIN
	tblPerson tblPrimaryPerson ON tblClient.PrimaryPersonId=tblPrimaryPerson.PersonId INNER JOIN
	tblAgency ON tblCommScen.AgencyId=tblAgency.AgencyId INNER JOIN
	tblCommRec ON tblCommStruct.CommRecId=tblCommRec.CommRecId
	
WHERE
	( CAST(CONVERT(char(10), tblCommBatch.BatchDate, 101) AS datetime) >= ''' + @date1 + ''' ) AND
	( CAST(CONVERT(char(10), tblCommBatch.BatchDate, 101) AS datetime) <= ''' + @date2 + ''' ) 
	 ' + @where + 
	'

UNION ALL



SELECT 
	tblCommStruct.CommRecId,
	tblagency.agencyid,
	tblCommStruct.CommScenId,
	tblCommRec.Abbreviation as CommRecipName,
	tblCommPay.CommPayId,
	tblClient.AccountNumber,
	(SELECT Top 1 Created FROM tblRoadmap WHERE ClientId=tblClient.ClientId AND ClientStatusId=5) as HireDate,
	tblAgency.Name as CompanyName,
	tblPrimaryPerson.FirstName,
	tblPrimaryPerson.LastName,
	tblEntryType.[Name] as FeeCategory,
	''' + @period + ''' as Period,
	'''' as SettlementNumber, 
	-tblRegister.Amount as OriginalBalance,

	(	-tblRegister.Amount -
		(SELECT 
			case when SUM(b.Amount) is null then 0 else sum(b.amount) end
		FROM 
			tblRegisterPayment b
		WHERE 
			b.FeeRegisterId=tblRegisterPayment.FeeRegisterId AND 
			b.RegisterPaymentId<=tblRegisterPayment.RegisterPaymentId)
	) as BeginningBalance,

	(-(	tblRegister.Amount +
		(SELECT 
			case when SUM(b.Amount) is null then 0 else sum(b.amount) end
		FROM 
			tblRegisterPayment b
		WHERE 
			b.FeeRegisterId=tblRegisterPayment.FeeRegisterId AND 
			b.RegisterPaymentId<=tblRegisterPayment.RegisterPaymentId)
	) + tblRegisterPayment.Amount) as EndingBalance,

	tblRegisterPayment.Amount as PaymentAmount,
	tblCommPay.ChargebackDate as PaymentDate,
	tblCommPay.[Percent] as Rate,
	tblCommPay.Amount as Amount

FROM 
	tblCommBatch INNER JOIN 
	(SELECT [Percent],CommChargeBackId,CommPayID,ChargeBackDate,RegisterPaymentId,CommStructID,-Amount as Amount,CommBatchId FROM tblCommChargeBack) tblCommPay on tblCommBatch.CommBatchId=tblCommPay.CommBatchId INNER JOIN 
	(SELECT RegisterPaymentId, PaymentDate, FeeRegisterId, -Amount as Amount from tblRegisterPayment) tblRegisterPayment ON tblCommPay.RegisterPaymentId=tblRegisterPayment.RegisterPaymentId INNER JOIN
	tblCommStruct ON tblCommPay.CommStructId=tblCommStruct.CommStructId INNER JOIN
	tblCommScen ON tblCommStruct.CommScenId=tblCommScen.CommScenId INNER JOIN	
	tblRegister ON tblRegisterPayment.FeeRegisterId = tblRegister.RegisterId INNER JOIN
	tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId INNER JOIN
	tblClient ON tblRegister.ClientId=tblClient.ClientId INNER JOIN
	tblPerson tblPrimaryPerson ON tblClient.PrimaryPersonId=tblPrimaryPerson.PersonId INNER JOIN
	tblAgency ON tblCommScen.AgencyId=tblAgency.AgencyId INNER JOIN
	tblCommRec ON tblCommStruct.CommRecId=tblCommRec.CommRecId 
	
WHERE
	( CAST(CONVERT(char(10), tblCommBatch.BatchDate, 101) AS datetime) >= ''' + @date1 + ''' ) AND
	( CAST(CONVERT(char(10), tblCommBatch.BatchDate, 101) AS datetime) <= ''' + @date2 + ''' ) 
	 ' + @where + 
	'


 ORDER BY ' + @orderby + ' tblRegisterPayment.PaymentDate OPTION (FAST 1000)'
)
GO
