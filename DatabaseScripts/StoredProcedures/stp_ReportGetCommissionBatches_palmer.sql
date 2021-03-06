/****** Object:  StoredProcedure [dbo].[stp_ReportGetCommissionBatches_palmer]    Script Date: 11/19/2007 15:27:41 ******/
DROP PROCEDURE [dbo].[stp_ReportGetCommissionBatches_palmer]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_ReportGetCommissionBatches_palmer]
	(
		@date1 datetime=null,
		@date2 datetime=null,
		@where varchar (8000) = '',
		@orderby varchar (8000) = '',
		@CompanyID int = 2
	)

as

if @date1 is null 
	set @date1 = convert(datetime,'1800.01.01')
if @date2 is null 
	set @date2 = convert(datetime,'9999.01.01')

if not @orderby is null and not @orderby=''
	set @orderby= @orderby + ' , '

if not @where is null and not @where=''
	set @where= ' and ' + @where

declare @NonAgents varchar(100)

SELECT
	@NonAgents = CommRecID
FROM
	tblNachaRoot
WHERE
	CompanyID = @CompanyID

exec('
SELECT
	batch.CommBatchID,
	commrec.Display as AgencyName,
	batchtransfer.CommRecID,
	sum(batchtransfer.Amount) as Amount
FROM
	tblCommBatch batch inner join
	tblCOmmBatchTransfer batchtransfer on batch.CommBatchID = batchtransfer.CommBatchID inner join
	tblCommRec commrec on batchtransfer.CommRecID = commrec.CommRecID
WHERE
	not batchtransfer.CommRecID in (' + @NonAgents + ') and
	( CAST(CONVERT(varchar(10), batch.BatchDate, 101) AS datetime) >= ''' + @date1 + ''' ) and
	( CAST(CONVERT(varchar(10), batch.BatchDate, 101) AS datetime) <= ''' + @date2 + ''' ) and
	(
		SELECT TOP 1
			CommStructID
		FROM
			tblCommPay
		WHERE
			CommBatchID = batch.CommBatchID
	) > 55
GROUP BY
	commrec.Display,
	batchtransfer.CommRecID,
	batch.CommBatchID
ORDER BY
	commrec.Display'
)
GO
