/****** Object:  StoredProcedure [dbo].[stp_DoRegisterUpdateFeeAmount]    Script Date: 11/19/2007 15:27:02 ******/
DROP PROCEDURE [dbo].[stp_DoRegisterUpdateFeeAmount]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_DoRegisterUpdateFeeAmount]
	(
		@registerid int
	)

as

---------------------------------------------------------------------------
-- (1) if originalamount is null, never updated for adjustment before
--     (a) copy over current amount to original amount
-- (2) change current mount to include all adjustments amounts
---------------------------------------------------------------------------

declare @totaladjustedamounts money

select
	@totaladjustedamounts = isnull(sum(amount), 0)
from
	tblregister
where
	adjustedregisterid = @registerid
	and void is null


if @totaladjustedamounts <> 0
	begin

		-- if originalamount has never been set, move the amount over
		update
			tblregister
		set
			originalamount = amount
		where
			registerid = @registerid and
			originalamount is null

		-- set amount equal to originalamount plus adjustments
		update
			tblregister
		set
			amount = originalamount + @totaladjustedamounts
		where
			registerid = @registerid

	end
else
	begin
		update
			tblregister
		set
			amount = originalamount
		where
			registerid = @registerid
	end
GO
