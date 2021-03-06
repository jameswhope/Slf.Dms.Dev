/****** Object:  StoredProcedure [dbo].[__TheCor_stp_IssueCommBatchOutRec]    Script Date: 12/19/2007 14:18:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[__TheCor_stp_IssueCommBatchOutRec]
	(
		@commbatchid int,
		@commscenid int,
		@companyid int,
		@parentcommrecid int
	)


as

set nocount on
set ansi_warnings off

declare @commrecid int
declare @order int
declare @amount money

declare @commbatchtransferid int

declare @transferamount money

declare @vtblBatchOut table
(
	CommRecID int,
	[Order] int,
	Amount money
)

INSERT INTO
	@vtblBatchOut
SELECT
	CommRecID,
	[Order],
	Amount
FROM
	#tblIssueCommBatch
WHERE
	CommScenID = @commscenid
	and CompanyID = @companyid
	and ParentCommRecID = @parentcommrecid
ORDER BY
	[Order]

declare cursor_BatchOut cursor local forward_only read_only for
		SELECT
			CommRecID,
			[Order],
			Amount
		FROM
			@vtblBatchOut

open cursor_BatchOut

fetch next from cursor_BatchOut into @commrecid, @order, @amount

while @@fetch_status = 0
begin
	INSERT INTO
		tblCommBatchTransfer
		(
			CommBatchID,
			CommRecID,
			ParentCommRecID,
			[Order],
			Amount,
			CompanyID
		)
	VALUES
		(
			@commbatchid,
			@commrecid,
			@parentcommrecid,
			@order,
			@amount,
			@companyid
		)

	set @commbatchtransferid = scope_identity()

	exec __TheCor_stp_IssueCommBatchOutRec @commbatchid, @commscenid, @companyid, @commrecid

	UPDATE
		tblCommBatchTransfer
	SET
		TransferAmount = isnull(TransferAmount, 0) + @amount
	WHERE
		CommBatchTransferID = @commbatchtransferid

	SELECT
		@transferamount = isnull(TransferAmount, 0)
	FROM
		tblCommBatchTransfer
	WHERE
		CommBatchTransferID = @commbatchtransferid

	UPDATE
		tblCommBatchTransfer
	SET
		TransferAmount = isnull(TransferAmount, 0) + @transferamount
	WHERE
		CommBatchID = @commbatchid
		and CommRecID = @parentcommrecid

	fetch next from cursor_BatchOut into @commrecid, @order, @amount
end

close cursor_BatchOut
deallocate cursor_BatchOut