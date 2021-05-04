/****** Object:  StoredProcedure [dbo].[stp_PayChargebackPaymentRec]    Script Date: 11/19/2007 15:27:25 ******/
DROP PROCEDURE [dbo].[stp_PayChargebackPaymentRec]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_PayChargebackPaymentRec]
(
	@registerpaymentid int,
	@commscenid int,
	@parentcommrecid int,
	@companyid int
)
as

-----------------------------------------------------------------------------------------------------
-- LOGIC FOR ISSUING CHARGEBACK AGAINST COMMISSION PAYMENT:
-- (1) In order (RLTD), loop through recipient recursively
-- (2) For each recipient, write out the chargeback values to tblcommchargeback, including:
--     (a) RegisterPaymentID - which will give us the client, fee, and payment info
--     (b) CommStructID - which will give us the recipient,  parent recipient, scenario, and percent
--     (c) Amount
-- (3) Sum and return the total percent used
-----------------------------------------------------------------------------------------------------


-- discretionary variables
declare @commstructid int
declare @commrecid int
declare @amount money
declare @paymentamount money
declare @amountchargedback money
declare @entrytypeid int
declare @percent money


-- (1) prepare loop for recipients against current parent and scenario
declare cursor_PayCommissionRec cursor local for
	select
		commstructid,
		commrecid
	from
		tblcommstruct
	where
		companyid = @companyid and
		commscenid = @commscenid and 
		parentcommrecid = @parentcommrecid
	order by
		[order]		

open cursor_PayCommissionRec

fetch next from cursor_PayCommissionRec into @commstructid, @commrecid
while @@fetch_status = 0

	begin

		set @amount = null
		set @paymentamount = null
		set @amountchargedback = null
		set @entrytypeid = null
		set @percent = null

		-- find original payment amount and entrytypeid
		select
			@paymentamount = tblregisterpayment.amount,
			@entrytypeid = tblregister.entrytypeid
		from
			tblregisterpayment inner join
			tblregister on tblregisterpayment.feeregisterid = tblregister.registerid
		where
			tblregisterpayment.registerpaymentid = @registerpaymentid

		-- find percent owed for this entrytype and commstruct
		select
			@percent = [percent]
		from
			tblcommfee
		where
			entrytypeid = @entrytypeid and
			commstructid = @commstructid

		-- assuming we found a fee payment amount, fee entrytype and percent for the commstruct...
		if not @paymentamount is null and not @entrytypeid is null and not @percent is null
			begin

				-- calculate the amount for this candidate
				set @amount = round(@paymentamount * @percent, 2)

				-- find amount already charged back already
				select
					@amountchargedback = sum(amount)
				from
					tblcommchargeback
				where
					registerpaymentid = @registerpaymentid

				-- amount must be less then amountleft which is equal to (paymentamount - amountchargedback)
				if (@paymentamount - @amountchargedback) < @amount
					begin
						set @amount = @paymentamount - @amountchargedback
					end

				-- assuming there is some positive amount to charge back....
				if @amount > 0
					begin

						-- (2) write out chargeback
						insert into tblcommchargeback
						(
							chargebackdate,
							registerpaymentid,
							commstructid,
							[percent],
							amount
						)
						values
						(
							getdate(),
							@registerpaymentid,
							@commstructid,
							@percent,
							@amount
						)

					end

			end

		-- recursively run this same proc again with this recipient as parent
		exec stp_PayChargebackPaymentRec @registerpaymentid, @commscenid, @commrecid, @companyid

		fetch next from cursor_PayCommissionRec into @commstructid, @commrecid

	end

close cursor_PayCommissionRec
deallocate cursor_PayCommissionRec
GO
 