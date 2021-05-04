IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PayFees')
	BEGIN
		DROP  Procedure  stp_PayFees
	END

GO

CREATE Procedure stp_PayFees
(
		@hidemessages bit = 1,
		@UserID int = 28
	)

as

set nocount on
set ansi_warnings off

---------------------------------------------------------------------------------------------------
-- LOGIC FOR ALL FEE COLLECTION:
-- (1) Grab all fees to be paid in the system.  Fees to be paid are:
--        (a) Must be negative (less than zero) amount
--        (b) Entry type must be marked as actual fee (fee=1)
--        (c) Cannot be marked as fully paid
--        (d) Cannot be marked as VOID
--        (e) Cannot be marked as BOUNCE
-- (2) Fees must be paid in order shown by client first, then entry
--      type, then transaction date.  This is important to remember
--      when returning the list of fees to be paid in step 1
---------------------------------------------------------------------------------------------------


-- discretionary variables
declare @registerid int
declare @CompanyID int
declare @marker datetime
declare @total int
declare @finished int
declare @percent money
declare @num int
declare @sum money


select
	@total = count(tblregister.registerid)
from
	tblregister inner join
	tblentrytype on tblregister.entrytypeid = tblentrytype.entrytypeid
where
	tblentrytype.fee = 1
	and amount < 0 
	and tblentrytype.fee = 1 
	and isfullypaid = 0 
	and void is null 
	and bounce is null


set @marker = getdate()
set @finished = 0
set @percent = 0

print '(' + convert(varchar(50), getdate(), 13) + ') Analyzing ' + convert(varchar(50), @total) + ' fees for possible payment collection...'


-- (1) open and loop all oustanding fees
declare cursor_a cursor for
	select
		tblregister.registerid, tblClient.CompanyID
	from
		tblregister 
		inner join tblentrytype on tblregister.entrytypeid = tblentrytype.entrytypeid
		inner join tblClient on tblRegister.ClientID = tblClient.ClientID
	where
	tblentrytype.fee = 1
	and amount < 0 
	and tblentrytype.fee = 1 
	and isfullypaid = 0 
	and void is null 
	and bounce is null
	order by
		tblregister.clientid desc, tblentrytype.[order], tblregister.transactiondate

open cursor_a

fetch next from cursor_a into @registerid, @CompanyID
while @@fetch_status = 0

	begin

		-- (2) run payment proc on each fee
		exec stp_payfee @registerid, @hidemessages, @UserID

		-- progress display
		set @finished = @finished + 1

		if ((convert(money, @finished) / convert(money, @total)) * convert(money, 100)) > (@percent + 1)
			begin

				set @percent = ((convert(money, @finished) / convert(money, @total)) * convert(money, 100))

				select
					@num = isnull(count(*), 0),
					@sum = isnull(sum(amount), 0)
				from
					tblregisterpayment
				where
					paymentdate >= @marker
				
				if (@CompanyID = 2)
					begin
						print ('PALMER CLIENT BELOW')
					end
				else
					begin
						print ('SEIDEMAN CLIENT BELOW')
					end				

				print '(' + convert(varchar(50), getdate(), 13) + ') Processed ' + convert(varchar(50), @finished) 
					+ ' fees (' + convert(varchar(50), @percent) + '%) and collected ' 
					+ convert(varchar(50), @num) + ' payments totalling $' + convert(varchar(50), @sum)

			end


		fetch next from cursor_a into @registerid, @CompanyID

	end

close cursor_a
deallocate cursor_a


set nocount off
set ansi_warnings on
GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

