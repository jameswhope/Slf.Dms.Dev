ALTER PROCEDURE [dbo].[stp_IssueCommBatchOut]
(
	@commbatchid int,
	@commscenid int,
	@companyid int,
	@parentcommrecid int,
	@trustid int
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
	Amount money,
	TrustID int
)


INSERT INTO
	@vtblBatchOut
SELECT
	CommRecID,
	[Order],
	Amount,
	TrustID
FROM
	#tblIssueCommBatch
WHERE
	CommScenID = @commscenid
	and CompanyID = @companyid
	and ParentCommRecID = @parentcommrecid
	and TrustID = @trustid
ORDER BY
	[Order]



declare cursor_BatchOut cursor local forward_only read_only for
	SELECT
		CommRecID,
		[Order],
		Amount,
		TrustID
	FROM
		@vtblBatchOut

open cursor_BatchOut

fetch next from cursor_BatchOut into @commrecid, @order, @amount, @trustid

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
				CompanyID,
				TrustID
			)
		VALUES
			(
				@commbatchid,
				@commrecid,
				@parentcommrecid,
				@order,
				@amount,
				@companyid,
				@trustid
			)

		set @commbatchtransferid = scope_identity()


		-- recursively run this same proc again with this recipient as parent
		exec stp_IssueCommBatchOut @commbatchid, @commscenid, @companyid, @commrecid, @trustid


		-- add the current amount to the current transferamount
		UPDATE
			tblCommBatchTransfer
		SET
			TransferAmount = isnull(TransferAmount, 0) + @amount
		WHERE
			CommBatchTransferID = @commbatchtransferid


		-- retrieve the current transferamount and add it to the parent transferamount
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
			and TrustID = @trustid


		fetch next from cursor_BatchOut into @commrecid, @order, @amount, @trustid
	end

close cursor_BatchOut
deallocate cursor_BatchOut