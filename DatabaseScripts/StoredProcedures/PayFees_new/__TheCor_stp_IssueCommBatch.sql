/****** Object:  StoredProcedure [dbo].[__TheCor_stp_IssueCommBatch]    Script Date: 12/19/2007 14:18:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[__TheCor_stp_IssueCommBatch]


as

set nocount on
set ansi_warnings off

declare @commscenid int
declare @commrecid int
declare @parentcommrecid int
declare @companyid int
declare @commbatchid int

declare @checkparents bit

declare @trustcommrec int

declare @switchdate datetime

BEGIN TRY
	set @switchdate = '05-16-2007'

	create table #tblIssueCommBatch
	(
		CompanyID int,
		CommScenID int,
		CommRecID int,
		ParentCommRecID int,
		[Order] int,
		Amount money
	)

	declare @vtblBatches table
	(
		ID int identity(1, 1),
		CompanyID int,
		CommScenID int,
		CommRecID int,
		ParentCommRecID int null,
		[Order] int,
		Amount money
	)

	declare @vtblComms table
	(
		CompanyID int,
		ID int,
		[Type] varchar(14),
		CommScenID int,
		CommRecID int,
		ParentCommRecID int,
		[Order] int,
		Amount money
	)

	INSERT INTO
		@vtblComms
	SELECT
		CompanyID,
		ID,
		[Type],
		CommScenID,
		(
			CASE
				WHEN
					CommRecID = 5
					and Created > @switchdate
				THEN
					24
				ELSE
					CommRecID
			END
		) as CommRecID,
		(
			CASE
				WHEN
					ParentCommRecID = 5
					and Created > @switchdate
				THEN
					24
				ELSE
					ParentCommRecID
			END
		) as ParentCommRecID,
		[Order],
		Amount
	FROM
		(
			SELECT
				c.Created,
				c.CompanyID,
				cp.CommPayID as ID,
				'CommPay' as [Type],
				cs.CommScenID,
				cs.CommRecID,
				cs.ParentCommRecID,
				cs.[Order],
				cp.Amount
			FROM
				tblCommPay as cp
				inner join tblRegisterPayment as rp on rp.RegisterPaymentID = cp.RegisterPaymentID
				inner join tblRegister as r on r.RegisterID = rp.FeeRegisterID
				inner join tblClient as c on c.ClientID = r.ClientID
				inner join tblCommStruct as cs on cs.CommStructID = cp.CommStructID
			WHERE
				cp.CommBatchID is null

			UNION ALL

			SELECT
				c.Created,
				c.CompanyID,
				cc.CommChargebackID as ID,
				'CommChargeback' as [Type],
				cs.CommScenID,
				cs.CommRecID,
				cs.ParentCommRecID,
				cs.[Order],
				-cc.Amount
			FROM
				tblCommChargeback as cc
				inner join tblRegisterPayment as rp on rp.RegisterPaymentID = cc.RegisterPaymentID
				inner join tblRegister as r on r.RegisterID = rp.FeeRegisterID
				inner join tblClient as c on c.ClientID = r.ClientID
				inner join tblCommStruct as cs on cs.CommStructID = cc.CommStructID
			WHERE
				cc.CommBatchID is null
		) as drvComms

	INSERT INTO
		@vtblBatches
	SELECT
		CompanyID,
		CommScenID,
		CommRecID,
		ParentCommRecID,
		[Order],
		sum(Amount) as Amount
	FROM
		@vtblComms
	GROUP BY
		CommScenID,
		CommRecID,
		ParentCommRecID,
		[Order],
		CompanyID

	SELECT
		ID,
		CompanyID,
		CommScenID,
		CommRecID,
		ParentCommRecID,
		[Order],
		Amount
	FROM
		@vtblBatches

	declare cursor_DeleteNegativeBatches cursor forward_only read_only for
		SELECT
			CommScenID,
			CommRecID,
			CompanyID
		FROM
			@vtblBatches
		WHERE
			Amount <= 0

	open cursor_DeleteNegativeBatches

	fetch next from cursor_DeleteNegativeBatches into @commscenid, @commrecid, @companyid

	while @@fetch_status = 0
	begin
		delete @vtblComms where CommScenID = @commscenid and CommRecID = @commrecid and CompanyID = @companyid
		delete @vtblBatches where CommScenID = @commscenid and CommRecID = @commrecid and CompanyID = @companyid

		fetch next from cursor_DeleteNegativeBatches into @commscenid, @commrecid, @companyid
	end

	close cursor_DeleteNegativeBatches
	deallocate cursor_DeleteNegativeBatches

	declare cursor_IssueCommBatch cursor forward_only read_only for
		SELECT DISTINCT
			CommScenID,
			CompanyID
		FROM
			@vtblComms
		ORDER BY
			CompanyID,
			CommScenID

	open cursor_IssueCommBatch

	fetch next from cursor_IssueCommBatch into @commscenid, @companyid

	while @@fetch_status = 0
	begin
		set @checkparents = 1

		SELECT TOP 1
			@trustcommrec = CommRecID
		FROM
			tblCommRec
		WHERE
			IsTrust = 1
			and CompanyID = @companyid 

		while @checkparents = 1
		begin
			if (SELECT count(DISTINCT ParentCommRecID) FROM @vtblBatches WHERE CommScenID = @commscenid and CompanyID = @companyid and not ParentCommRecID = @trustcommrec) > 0
			begin
				declare cursor_ParentRec cursor forward_only read_only for
					SELECT DISTINCT
						ParentCommRecID
					FROM
						@vtblBatches
					WHERE
						CommScenID = @commscenid
						and CompanyID = @companyid
						and not ParentCommRecID = @trustcommrec

				open cursor_ParentRec

				fetch next from cursor_ParentRec into @parentcommrecid

				while @@fetch_status = 0
				begin
					if (SELECT count(*) FROM @vtblBatches WHERE CommScenID = @commscenID and CompanyID = @companyid and CommRecID = @parentcommrecid) = 0
					begin
						INSERT INTO
							@vtblBatches
						SELECT
							CompanyID,
							CommScenID,
							CommRecID,
							ParentCommRecID,
							[Order],
							0
						FROM
							tblCommStruct
						WHERE
							CommScenID = @commscenid
							and CompanyID = @companyid
							and CommRecID = @parentcommrecid

						set @checkparents = 1
					end
					else
					begin
						set @checkparents = 0
					end

					fetch next from cursor_ParentRec into @parentcommrecid
				end

				close cursor_ParentRec
				deallocate cursor_ParentRec
			end
			else
			begin
				set @checkparents = 0
			end
		end

		INSERT INTO
			tblCommBatch
		VALUES
			(
				@commscenid,
				getdate()
			)

		set @commbatchid = scope_identity()

		INSERT INTO
			#tblIssueCommBatch
		SELECT
			CompanyID,
			CommScenID,
			CommRecID,
			ParentCommRecID,
			[Order],
			Amount
		FROM
			@vtblBatches

		exec __TheCor_stp_IssueCommBatchOutRec @commbatchid, @commscenid, @companyid, @trustcommrec

		truncate table #tblIssueCommBatch

		UPDATE
			tblCommPay
		SET
			CommBatchID = @commbatchid
		WHERE
			CommPayID in
				(
					SELECT
						ID
					FROM
						@vtblComms
					WHERE
						[Type] = 'CommPay'
						and CommScenID = @commscenid
						and CompanyID = @companyid
				)

		UPDATE
			tblCommChargeback
		SET
			CommBatchID = @commbatchid
		WHERE
			CommPayID in
				(
					SELECT
						ID
					FROM
						@vtblComms
					WHERE
						[Type] = 'CommChargeback'
						and CommScenID = @commscenid
						and CompanyID = @companyid
				)

		fetch next from cursor_IssueCommBatch into @commscenid, @companyid
	end

	close cursor_IssueCommBatch
	deallocate cursor_IssueCommBatch

	drop table #tblIssueCommBatch
END TRY
BEGIN CATCH
	close cursor_ParentRec
	deallocate cursor_ParentRec

	close cursor_IssueCommBatch
	deallocate cursor_IssueCommBatch

	drop table #tblIssueCommBatch

	declare @errorMessage nvarchar(MAX) set @errorMessage = ERROR_MESSAGE()
	declare @errorSeverity int set @errorSeverity = ERROR_SEVERITY()
	declare @errorState int set @errorState = ERROR_STATE()

	RAISERROR(@errorMessage, @errorSeverity, @errorState)
END CATCH