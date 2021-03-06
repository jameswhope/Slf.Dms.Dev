/****** Object:  StoredProcedure [dbo].[stp_ReportGetAgencyCommission]    Script Date: 11/19/2007 15:27:40 ******/
DROP PROCEDURE [dbo].[stp_ReportGetAgencyCommission]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_ReportGetAgencyCommission]
	(
		@companyids nvarchar(50),
		@date1 datetime=null,
		@date2 datetime=null,
		@commrecid nvarchar(50),
		@range varchar(50)='',
		@ClientCreatedDateFrom datetime = '1/1/1900',
		@ClientCreatedDateTo datetime = '1/1/2050'
	)

as

if @date1 is null 
	set @date1 = convert(datetime,'1800.01.01')
if @date2 is null 
	set @date2 = convert(datetime,'9999.01.01')

create table #temp
(
	CommBatchID int,
	CompanyID int
)

INSERT INTO
	#temp
SELECT
	cp.CommBatchID,
	cs.CompanyID
FROM
	tblCommPay as cp
	inner join tblCommStruct as cs on cs.CommStructID = cp.CommStructID
	inner join tblRegisterPayment p on p.RegisterPaymentId = cp.RegisterPaymentID
	inner join tblRegister r on r.RegisterId = p.FeeRegisterId
	inner join tblClient c on c.ClientID = r.ClientID
		and (c.Created between @ClientCreatedDateFrom and @ClientCreatedDateTo)
GROUP BY
	cp.CommBatchID,
	cs.CompanyID

exec ('
SELECT ' + @range + '
	batch.CommBatchID,
	batch.BatchDate,
	sum(batchtransfer.Amount) as Amount,
	(SELECT ShortCoName FROM tblCompany WHERE CompanyID = comp.CompanyID) as Company,
	batchtransfer.CommRecID
FROM
	tblCommBatch batch inner join
	tblCommBatchTransfer batchtransfer on batch.CommBatchID = batchtransfer.CommBatchID inner join
	tblCommRec commrec on batchtransfer.CommRecID = commrec.CommRecID inner join
	#temp as comp on comp.CommBatchID = batch.CommBatchID
WHERE
	( CAST(CONVERT(varchar(10), batch.BatchDate, 101) AS datetime) >= ''' + @date1 + ''' ) and
	( CAST(CONVERT(varchar(10), batch.BatchDate, 101) AS datetime) <= ''' + @date2 + ''' ) and
	batchtransfer.CommRecID in (' + @CommRecID + ') and
	comp.CompanyID in (' + @companyids + ')
GROUP BY
	batch.CommBatchID,
	batch.BatchDate,
	comp.CompanyID,
	batchtransfer.CommRecID
ORDER BY
	batch.BatchDate DESC
')

drop table #temp
GO
