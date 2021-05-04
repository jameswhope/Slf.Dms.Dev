IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Checkscan_Detail')
	BEGIN
		DROP  Procedure  stp_Checkscan_Detail
	END

GO

CREATE PROCEDURE [dbo].[stp_Checkscan_Detail]

AS
	BEGIN
		declare @tblGrid table(RECStatus varchar(500),Created datetime,TotalRECItems int,TotalRECAmount money,ACKStatus varchar(500)
		,TotalAckItems int,TotalAckAmount money,TotalAdjusted int
		,TotalAdjustedAmount money)

		insert into @tblGrid
		select rfh.FileValidationStatus[RECStatus]
		, convert(varchar, rfh.Created, 100) [Created]
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
		GROUP BY rfh.FileValidationStatus, convert(varchar, rfh.Created, 100) ,rfc.TotalItemCount ,rfc.FileTotalAmount
		,afh.FileValidationStatus,afc.TotalItems,afc.FileTotalAmount
		order by  rfh.Created desc

		SELECT RECStatus,Created,TotalRECItems,TotalRECAmount,ACKStatus,TotalAckItems,TotalAckAmount,TotalAdjusted,TotalAdjustedAmount,
		TotalAckItems-TotalAdjusted[TotalAccepted],TotalAckAmount-TotalAdjustedAmount[TotalAcceptedAmount]
		from @tblGrid
		order by Created desc
	END