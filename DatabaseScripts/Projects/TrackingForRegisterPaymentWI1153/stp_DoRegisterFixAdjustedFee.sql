/****** Object:  StoredProcedure [dbo].[stp_DoRegisterFixAdjustedFee]    Script Date: 08/10/2009 09:55:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[stp_DoRegisterFixAdjustedFee]
	(
		@registerid int,
		@docleanup bit = 1,
		@UserID int = 28
	)

as

declare @clientid int
declare @adjustedregisterid int

select
	@clientid = clientid,
	@adjustedregisterid = adjustedregisterid
from
	tblregister
where
	registerid = @registerid


if not @adjustedregisterid is null
	begin

		-- tweak new total amount (if not done first, reset sproc will not adjust flag properly)
		exec stp_DoRegisterUpdateFeeAmount @adjustedregisterid


		-- make sure the total fee amount was not reduced below total payments made
		declare @sumpayments as money
		declare @currentamount as money

		select
			@sumpayments = isnull(sum(amount), 0)
		from
			tblregisterpayment
		where
			feeregisterid = @adjustedregisterid

		select
			@currentamount = isnull(amount, 0)
		from
			tblregister
		where
			registerid = @adjustedregisterid


		if @sumpayments > @currentamount -- total payments are larger then total fee
			begin

				-- deterime if all payments for this fee can be deleted
				declare @atleastonefailed bit
				declare @registerpaymentid int

				set @atleastonefailed = 0

				declare cursor_fafa cursor local for select registerpaymentid from tblregisterpayment where feeregisterid = @adjustedregisterid
				open cursor_fafa

				fetch next from cursor_fafa into @registerpaymentid
				while @@fetch_status = 0
					begin

						if dbo.udf_CanDeleteRegisterPayment(@registerpaymentid) = 0
							begin
								set @atleastonefailed = 1
								break
							end

						fetch next from cursor_fafa into @registerpaymentid
					end
				close cursor_fafa
				deallocate cursor_fafa


				-- cycle again, but this time either delete or void
				declare cursor_fafb cursor local for select registerpaymentid from tblregisterpayment where feeregisterid = @adjustedregisterid
				open cursor_fafb

				fetch next from cursor_fafb into @registerpaymentid
				while @@fetch_status = 0
					begin

						if @atleastonefailed = 0 -- nothing failed, so delete them all
							begin
								exec stp_DeleteRegisterPayment @registerpaymentid, 0
							end
						else -- at least one failed, so void them all
							begin
								exec stp_DoRegisterPaymentVoid @registerpaymentid, 0, @UserID
							end

						fetch next from cursor_fafb into @registerpaymentid
					end
				close cursor_fafb
				deallocate cursor_fafb

			end


		if @docleanup = 1
			begin
				exec stp_DoRegisterCleanup @clientid
			end

	end