/****** Object:  StoredProcedure [dbo].[stp_ReportGetAgencyBatches_all]    Script Date: 11/19/2007 15:27:39 ******/
DROP PROCEDURE [dbo].[stp_ReportGetAgencyBatches_all]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_ReportGetAgencyBatches_all]
	(
		@date1 datetime=null,
		@date2 datetime=null,
		@commrecid nvarchar(50),
		@range varchar(50)=''
	)

as

if @date1 is null 
	set @date1 = convert(datetime,'1800.01.01')
if @date2 is null 
	set @date2 = convert(datetime,'9999.01.01')

exec ('
SELECT ' + @range + '
	batch.CommBatchID,
	batch.BatchDate,
	sum(batchtransfer.Amount) as Amount
FROM
	tblCommBatch batch inner join
	tblCommBatchTransfer batchtransfer on batch.CommBatchID = batchtransfer.CommBatchID inner join
	tblCommRec commrec on batchtransfer.CommRecID = commrec.CommRecID
WHERE
	( CAST(CONVERT(varchar(10), batch.BatchDate, 101) AS datetime) >= ''' + @date1 + ''' ) and
	( CAST(CONVERT(varchar(10), batch.BatchDate, 101) AS datetime) <= ''' + @date2 + ''' ) and
	batchtransfer.CommRecID in (' + @CommRecID + ')
GROUP BY
	batch.CommBatchID,
	batch.BatchDate
ORDER BY
	batch.BatchDate DESC
')
GO
