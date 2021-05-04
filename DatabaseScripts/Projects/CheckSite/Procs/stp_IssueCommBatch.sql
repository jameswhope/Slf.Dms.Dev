ALTER procedure [dbo].[stp_IssueCommBatch]

AS

/*
	History:
	9.22.08		jhernandez		Merged Cor's rewrite with CheckSite version.
	10.15.08	jhernandez		Removed Stonewall/Avert switch dates. Using multiple scenarios per agency now. 
	4.2.09		jhernandez		Delete neg batches logic now takes into consideration the parent. Affects recipients
								with batches from multiple parents (TSLF OA & Antilla), if one batch per scenario
								was negative neither would get batched until both parents could batch positive amounts.
	6.22.09		jhernandez		Batch items must be processed through the trust the payment originated
								through. View used to determine when clients were converted.
*/

set nocount on
set ansi_warnings off

declare @commscenid int
declare @commrecid int
declare @parentcommrecid int
declare @companyid int
declare @commbatchid int
declare @checkparents bit
declare @trustid int
declare @trustcommrec int


BEGIN TRY


create table #tblIssueCommBatch
(
	CompanyID int,
	TrustID int,
	CommScenID int,
	CommRecID int,
	ParentCommRecID int,
	[Order] int,
	Amount money
)

declare @vtblBatches table
(
	ID int identity(1,1),
	CompanyID int,
	TrustID int,
	CommScenID int,
	CommRecID int,
	ParentCommRecID int null,
	[Order] int,
	Amount money
)

declare @vtblComms table
(
	CompanyID int,
	TrustID int,
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
	TrustID,
	ID,
	[Type],
	CommScenID,
	CommRecID,
	ParentCommRecID,
	[Order],
	Amount
FROM
(
	SELECT
		cs.CompanyID,
		case when v.converted is null then c.TrustID
			 when v.converted > rp.paymentdate then v.OrigTrustID
			 else c.TrustID 
		end [TrustID],
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
		left join vw_ClientTrustConvDate v on v.clientid = c.clientid
	WHERE
		cp.CommBatchID is null

	UNION ALL

	SELECT
		cs.CompanyID,
		case when v.converted is null then c.TrustID
			 when v.converted > rp.paymentdate then v.OrigTrustID
			 else c.TrustID 
		end [TrustID],
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
		left join vw_ClientTrustConvDate v on v.clientid = c.clientid
	WHERE
		cc.CommBatchID is null
) as drvComms



INSERT INTO
	@vtblBatches
SELECT
	CompanyID,
	TrustID,
	CommScenID,
	CommRecID,
	ParentCommRecID,
	[Order],
	sum(Amount) as Amount
FROM
	@vtblComms
GROUP BY
	CompanyID,
	TrustID,
	CommScenID,
	CommRecID,
	ParentCommRecID,
	[Order]



declare cursor_DeleteNegativeBatches cursor forward_only read_only for
	SELECT
		CompanyID,
		TrustID,
		CommScenID,
		CommRecID,
		ParentCommRecID
	FROM
		@vtblBatches
	WHERE
		Amount <= 0

open cursor_DeleteNegativeBatches

fetch next from cursor_DeleteNegativeBatches into @companyid, @trustid, @commscenid, @commrecid, @parentcommrecid

while @@fetch_status = 0
	begin
		delete @vtblComms where CompanyID = @companyid and TrustID = @trustid and CommScenID = @commscenid and CommRecID = @commrecid and ParentCommRecID = @ParentCommRecID
		delete @vtblBatches where CompanyID = @companyid and TrustID = @trustid and CommScenID = @commscenid and CommRecID = @commrecid and ParentCommRecID = @ParentCommRecID

		fetch next from cursor_DeleteNegativeBatches into @companyid, @trustid, @commscenid, @commrecid, @parentcommrecid
	end

close cursor_DeleteNegativeBatches
deallocate cursor_DeleteNegativeBatches



declare cursor_IssueCommBatch cursor forward_only read_only for
	SELECT DISTINCT
		CompanyID,
		TrustID,
		CommScenID
	FROM
		@vtblComms
	ORDER BY
		CompanyID,
		TrustID,
		CommScenID

open cursor_IssueCommBatch

fetch next from cursor_IssueCommBatch into @companyid, @trustid, @commscenid

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
                if (SELECT count(DISTINCT ParentCommRecID) FROM @vtblBatches WHERE CommScenID = @commscenid and CompanyID = @companyid and not ParentCommRecID = @trustcommrec and TrustID = @trustid) > 0
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
								and TrustID = @trustid

						open cursor_ParentRec

						fetch next from cursor_ParentRec into @parentcommrecid
				
                        while @@fetch_status = 0
							begin
								if (SELECT count(*) FROM @vtblBatches WHERE CommScenID = @commscenID and CompanyID = @companyid and CommRecID = @parentcommrecid and TrustID = @trustid) = 0
									begin
										INSERT INTO
											@vtblBatches
										SELECT
											CompanyID,
											@trustid,
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
			TrustID,
			CommScenID,
			CommRecID,
			ParentCommRecID,
			[Order],
			Amount
		FROM
			@vtblBatches

		exec stp_IssueCommBatchOut @commbatchid, @commscenid, @companyid, @trustcommrec, @trustid

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
						and TrustID = @trustid
				)

		UPDATE
			tblCommChargeback
		SET
			CommBatchID = @commbatchid
		WHERE
			CommChargebackID in
				(
					SELECT
						ID
					FROM
						@vtblComms
					WHERE
						[Type] = 'CommChargeback'
						and CommScenID = @commscenid
						and CompanyID = @companyid
						and TrustID = @trustid
				)

		fetch next from cursor_IssueCommBatch into @companyid, @trustid, @commscenid
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
