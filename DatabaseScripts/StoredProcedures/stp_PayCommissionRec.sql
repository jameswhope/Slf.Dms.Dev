/****** Object:  StoredProcedure [dbo].[stp_PayCommissionRec]    Script Date: 11/19/2007 15:27:26 ******/
DROP PROCEDURE [dbo].[stp_PayCommissionRec]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_PayCommissionRec]
	(
		@registerpaymentid int,
		@commscenid int,
		@parentcommrecid int = null
	)

as


------------------------------------------------------------------
-- LOGIC FOR COMMISSION PAYMENT:
-- (1) In order (RLTD), loop through recipient recursively
-- (2) For each recipient, write out the commission values
--		to tblregisterpaymentcommission including the following:
--     (a) RegisterPaymentID - which will give us the
--         client, fee, and payment info
--     (b) CommStructID - which will give us the recipient, 
--         parent recipient, scenario, and percent
--     (c) Amount
-- (3) Sum and return the total percent used
------------------------------------------------------------------


-- discretionary variables
declare @commstructid int
declare @commfeeid int

declare @amount money
declare @paymentamount money
declare @amountpaid money
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
		(commscenid = @commscenid and
		parentcommrecid = @parentcommrecid) or
		(
			commscenid = @commscenid and
			parentcommrecid is null and
			@parentcommrecid is null
		)
	order by
		[order]

open cursor_PayCommissionRec

fetch next from cursor_PayCommissionRec into @commstructid, @commfeeid
while @@fetch_status = 0

	begin

		set @amount = null
		set @paymentamount = null
		set @amountpaid = null
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

				-- find amount already paid out in commission already
				select
					@amountpaid = sum(amount)
				from
					tblcommpay
				where
					registerpaymentid = @registerpaymentid

				-- amount must be less then amountleft which is equal to (paymentamount - amountpaid)
				if (@paymentamount - @amountpaid) < @amount
					begin
						set @amount = @paymentamount - @amountpaid
					end

				-- assuming there is some positive amount to pay....
				if @amount > 0
					begin

						-- (2) write out payment
						insert into tblcommpay
						(
							registerpaymentid,
							commstructid,
							[percent],
							amount
						)
						values
						(
							@registerpaymentid,
							@commstructid,
							@percent,
							@amount
						)

					end

			end

		-- recursively run this same proc again with this recipient as parent
		exec stp_PayCommissionRec @registerpaymentid, @commscenid, @commfeeid

		fetch next from cursor_PayCommissionRec into @commstructid, @commfeeid

	end

close cursor_PayCommissionRec
deallocate cursor_PayCommissionRec
GO
