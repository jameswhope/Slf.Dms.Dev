/****** Object:  StoredProcedure [dbo].[stp_PayFeeForClient]    Script Date: 11/19/2007 15:27:27 ******/
DROP PROCEDURE [dbo].[stp_PayFeeForClient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_PayFeeForClient]
	(
		@clientid int,
		@hidemessages bit = 1
	)

as


--------------------------------------------------------------------------
-- LOGIC FOR CLIENT FEE PAYMENTS:
-- (1) Grab all fees to be paid for client.  Fees to be paid are:
--        (a) Only fees for this client
--        (b) Must be negative (less then zero) amount
--        (c) Entry type must be marked as actual fee (fee=1)
--        (d) Cannot be marked as fully paid
--        (d) Cannot be marked as VOID
--        (e) Cannot be marked as BOUNCED
--        (f) Order By entry type, then transactiondate
-- (2) Fees must be paid in order shown in entrytype table.  This
--      is important to remember when returning the list of fees 
--      to be paid in step 1
--------------------------------------------------------------------------


-- discretionary variables
declare @feeregisterid int
declare @adjustmentregisterid int


-- (1) open and loop the fees for this client
declare cursor_a cursor for
	select
		tblregister.registerid
	from
		tblregister inner join
		tblentrytype on tblregister.entrytypeid = tblentrytype.entrytypeid
	where
		clientid = @clientid and
		amount < 0 and
		tblentrytype.fee = 1 and
		isfullypaid = 0 and
		void is null and
		bounce is null
	order by
		tblentrytype.[order], tblregister.transactiondate, tblregister.registerid

open cursor_a

fetch next from cursor_a into @feeregisterid
while @@fetch_status = 0

	begin

		-- (2) run payment proc on fee
		exec stp_payfee @feeregisterid, @hidemessages

		fetch next from cursor_a into @feeregisterid
	end
close cursor_a
deallocate cursor_a
GO
