IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Checkscan_Summary')
	BEGIN
		DROP  Procedure  stp_Checkscan_Summary
	END

GO
CREATE PROCEDURE stp_Checkscan_Summary
AS
begin

declare @tblGrid table(RECStatus varchar(500),Created datetime,TotalRECItems int,TotalRECAmount money,ACKStatus varchar(500)
,TotalAckItems int,TotalAckAmount money,TotalAdjusted int
,TotalAdjustedAmount money)

insert into @tblGrid
select rfh.FileValidationStatus[RECStatus]
, rfh.Created
, cast(rfc.TotalItemCount as int) [TotalRECItems]
, cast(left(rfc.FileTotalAmount,len(rfc.FileTotalAmount)-2) + '.' + right(rfc.FileTotalAmount,2) as money) [TotalRECAmount]
, afh.FileValidationStatus[ACKStatus]
, isnull(cast(afc.TotalItems as int),0) [TotalAckItems]
, isnull(cast(left(afc.FileTotalAmount,len(afc.FileTotalAmount)-2) + '.' + right(afc.FileTotalAmount,2) as money),0)[TotalAckAmount]
, count(ackadj.ItemAdjustmentDetailId)[TotalAdjusted]
, sum(isnull(cast(left(ackadj.AmountOfItem,len(ackadj.AmountOfItem)-2) + '.' + right(ackadj.AmountOfItem,2) as money),0))[TotalAdjustedAmount]
from [wa].dbo.tblICLRECFileHeader_05 rfh
left join [wa].dbo.tblICLACKFileHeader_01 afh on afh.FileName=rfh.FileName
LEFT JOIN [WA].dbo.tblICLRECFileControl_09 rfc ON rfc.FileHeaderID = rfh.FileHeaderId
LEFT join [WA].dbo.tblICLACKFileControl_99 afc on afh.FileHeaderId = afc.FileHeaderID
left JOIN [WA].dbo.tblICLACKCashLetterHeader_10 aclh ON aclh.FileHeaderID = afh.FileHeaderID
left JOIN [WA].dbo.tblICLACKItemAdjustmentDetail_25 ackadj ON ackadj.CashLetterHeaderID = aclh.CashLetterHeaderId
GROUP BY rfh.FileValidationStatus, rfh.Created,rfc.TotalItemCount ,rfc.FileTotalAmount
,afh.FileValidationStatus,afc.TotalItems,afc.FileTotalAmount
order by  rfh.Created desc

SELECT RECStatus,
count(*)[Total Files],
sum(TotalRECItems)[TotalRECItems],
sum(TotalRECAmount)[TotalRECAmount],
ACKStatus,
sum(TotalAckItems)[TotalAckItems],
sum(TotalAckAmount)[TotalAckAmount],
sum(TotalAdjusted)[TotalAdjusted],
sum(TotalAdjustedAmount)[TotalAdjustedAmount],
sum(TotalAckItems-TotalAdjusted)[TotalAccepted],
sum(TotalAckAmount-TotalAdjustedAmount)[TotalAcceptedAmount]
from @tblGrid
group by RECStatus,ACKStatus


END

GRANT EXEC ON stp_Checkscan_Summary TO PUBLIC