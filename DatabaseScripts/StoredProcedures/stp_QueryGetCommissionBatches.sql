/****** Object:  StoredProcedure [dbo].[stp_QueryGetCommissionBatches]    Script Date: 11/19/2007 15:27:33 ******/
DROP PROCEDURE [dbo].[stp_QueryGetCommissionBatches]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_QueryGetCommissionBatches]
	(
		@date1 datetime=null,
		@date2 datetime=null,
		
		@where varchar (8000) = '',
		@orderby varchar (8000) = ''
	)

as

if @date1 is null 
	set @date1 = convert(datetime,'1800.01.01')
if @date2 is null 
	set @date2 = convert(datetime,'9999.01.01')

if not @orderby is null and not @orderby=''
	set @orderby= ' order by ' + @orderby 

exec('
SELECT 
	tblCommBatch.BatchDate,
	tblCommRec.Abbreviation as CommRecName,
	parent.Abbreviation as ParentCommRecName,
	(SELECT Count(*) / 2 FROM tblNachaRegister nnr WHERE nnr.Type=''CommBatchTransferID'' AND nnr.TypeId=tblCommBatchTransfer.CommBatchTransferId) AS ACHTries,
	tblCommBatchTransfer.*
FROM
	tblCommBatch INNER JOIN
	tblCommBatchTransfer ON tblCommBatch.CommBatchId=tblCommBatchTransfer.CommBatchId INNER JOIN
	tblCommRec ON tblCommBatchTransfer.CommRecId=tblCommRec.CommRecId LEFT OUTER JOIN
	tblCommRec parent ON tblCommBatchTransfer.ParentCommRecId=parent.CommRecId
WHERE
	( CAST(CONVERT(char(10), tblCommBatch.BatchDate, 101) AS datetime) >= ''' + @date1 + ''' ) AND
	( CAST(CONVERT(char(10), tblCommBatch.BatchDate, 101) AS datetime) <= ''' + @date2 + ''' ) 
	 ' + @where + 
	 @orderby 
)
GO
