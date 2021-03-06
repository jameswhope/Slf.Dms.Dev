/****** Object:  StoredProcedure [dbo].[stp_DoRegisterReset]    Script Date: 11/19/2007 15:27:02 ******/
DROP PROCEDURE [dbo].[stp_DoRegisterReset]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_DoRegisterReset]
	(
		@registerid int
	)

as


-----------------------------------------------------------
-- LOGIC FOR RESETTING A REGISTER
-- (1) Determine if it's a debit or a credit
-- (2) If it's a debit, check tblregisterpayment
--     for all payments made against it.  If the
--     sum of those payments equals the original
--     fee amount, then isfullypaid = 1, else 0
-- (3) If it's a credit, check tblregisterpaymentdeposit
--     for all payment deposits made with it.  If the
--     sum of those payment deposits equals the original
--     credit amount, the isfullypaid = 1, else 0
-----------------------------------------------------------


-- (1) determine debit or credit
declare @amount money

select
	@amount = coalesce(amount, 0)
from
	tblregister
where
	registerid = @registerid


if @amount < 0
	begin

		-- (2) Since debit, check register payments
		declare @sumregisterpayments money

		-- don't count any fee payments that are voided or bounced
		select
			@sumregisterpayments = coalesce(sum(amount), 0)
		from
			tblregisterpayment
		where
			feeregisterid = @registerid and
			bounced = 0 and
			voided = 0

		if @sumregisterpayments = abs(@amount)
			begin
				update tblregister set isfullypaid = 1 where registerid = @registerid
			end
		else
			begin
				update tblregister set isfullypaid = 0 where registerid = @registerid
			end

	end
else
	begin

		-- (3) Since credit, check register payment deposits
		declare @sumregisterpaymentdeposits money

		-- don't count any payment deposits that are voided or bounced
		select
			@sumregisterpaymentdeposits = coalesce(sum(amount), 0)
		from
			tblregisterpaymentdeposit
		where
			depositregisterid = @registerid and
			bounced = 0 and
			voided = 0

		if @sumregisterpaymentdeposits = @amount
			begin
				update tblregister set isfullypaid = 1 where registerid = @registerid
			end
		else
			begin
				update tblregister set isfullypaid = 0 where registerid = @registerid
			end

	end
GO
