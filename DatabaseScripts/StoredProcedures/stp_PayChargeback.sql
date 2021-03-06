/****** Object:  StoredProcedure [dbo].[stp_PayChargeback]    Script Date: 11/19/2007 15:27:25 ******/
DROP PROCEDURE [dbo].[stp_PayChargeback]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_PayChargeback]
	(
		@registerid int
	)

as

------------------------------------------------------------------------------------------
-- LOGIC FOR PAYING CHARGEBACKS
-- (1) Prepare a table of register payments that were affected by this
--     register, including:
--     (a) payments related to this register as a deposit
--     (b) payment deposits related to this register as a deposit
--     (c) payments related to this register as a fee
--     (d) payment deposits related to this register as a fee
-- (2) Fill the temp table with all of the matching register payment ids from above
-- (3) Loop through list (uniquely) and execute the chargeback process
-- (4) Dispose the temp table
------------------------------------------------------------------------------------------


-- discretionary variables
declare @registerpaymentid int
declare @numcoms int


-- (1) prepare the temp table
create table #tbl ( registerpaymentid int )


-- (2) find and insert the payments that match
insert into
	#tbl
select
	registerpaymentid
from
	tblregisterpayment
where
	feeregisterid = @registerid

insert into
	#tbl
select
	registerpaymentid
from
	tblregisterpaymentdeposit
where
	depositregisterid = @registerid


-- (3) loop and enter chargebacks
declare cursor_PayChargeback cursor local for select distinct * from #tbl

open cursor_PayChargeback

fetch next from cursor_PayChargeback into @registerpaymentid

while @@fetch_status = 0
	begin

		-- reinitialize
		set @numcoms = null


		-- (3.1) determine if there are any commpay records issued for this payment already
		select
			@numcoms = count(commpayid)
		from
			tblcommpay
		where
			registerpaymentid = @registerpaymentid


		-- (3.2) if comms exist, chargeback those only, otherwise reevaluate the entire payment for chargeback
		if not @numcoms is null and @numcoms > 0
			begin
				exec stp_PayChargebackAmount @registerpaymentid
			end
		else
			begin
				exec stp_PayChargebackPayment @registerpaymentid
			end


		fetch next from cursor_PayChargeback into @registerpaymentid
	end

close cursor_PayChargeback
deallocate cursor_PayChargeback


-- (4) dispose the temp table
drop table #tbl
GO
