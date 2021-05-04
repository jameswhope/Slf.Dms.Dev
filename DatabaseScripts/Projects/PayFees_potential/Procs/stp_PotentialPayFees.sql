
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PotentialPayFees')
	BEGIN
		DROP Procedure stp_PotentialPayFees
	END
GO 

create procedure [dbo].[stp_PotentialPayFees]
(
	@DaysToProject int = 10
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
declare @depositday int
declare @day int
declare @fordate datetime
declare @seed int


-- projecting the next 30 days..
set @day = 1 -- start with tomorrow

while @day <= @DaysToProject begin

	set @fordate = cast(convert(varchar(10), dateadd(day,@day,getdate()), 101) as datetime)
	set @depositday = datepart(day, @fordate)


	-- reset temp tables
	truncate table tblpotentialregistertmp
	truncate table tblpotentialregisterpaymenttmp
	truncate table tblpotentialregisterpaymentdeposittmp
	
	-- reseed tables for inserting
	select @seed = max(registerid)+1 from tblregister
	dbcc checkident (tblpotentialregistertmp, reseed, @seed) WITH NO_INFOMSGS

	select @seed = max(registerpaymentid)+1 from tblregisterpayment
	dbcc checkident (tblpotentialregisterpaymenttmp, reseed, @seed) WITH NO_INFOMSGS

	select @seed = max(registerpaymentdepositid)+1 from tblregisterpaymentdeposit
	dbcc checkident (tblpotentialregisterpaymentdeposittmp, reseed, @seed) WITH NO_INFOMSGS


	-- add projected deposits into register temp table, includes ach/adhocs/rules/checks
	exec stp_PotentialCollectDeposits @fordate


	-- add all existing register entries for this set of clients
	set identity_insert tblpotentialregistertmp on

	insert tblpotentialregistertmp (registerid,clientid,transactiondate,amount,isfullypaid,entrytypeid,entrytypeorder,fee,hold,[clear],adjustedregisterid,feemonth,feeyear,achmonth,achyear)
	select registerid,clientid,transactiondate,amount,isfullypaid,e.entrytypeid,e.[order],e.fee,hold,[clear],adjustedregisterid,feemonth,feeyear,achmonth,achyear
	from tblregister r
	join tblentrytype e on e.entrytypeid = r.entrytypeid
	where r.clientid in (select distinct clientid from tblpotentialregistertmp)
	and r.void is null
	and r.bounce is null

	set identity_insert tblpotentialregistertmp off


	-- add projected monthly fees to register temp table
	exec stp_PotentialCollectMonthlyFee @fordate


	-- get existing payments
	set identity_insert tblpotentialregisterpaymenttmp on

	insert tblpotentialregisterpaymenttmp (RegisterPaymentId,PaymentDate,FeeRegisterId,Amount,PFOBalance,SDABalance,[Clear])
	select RegisterPaymentId,PaymentDate,FeeRegisterId,rp.Amount,PFOBalance,SDABalance,rp.[Clear]
	from tblregisterpayment rp
	join tblpotentialregistertmp r on r.registerid = rp.feeregisterid 
	where rp.voided = 0
	and rp.bounced = 0

	set identity_insert tblpotentialregisterpaymenttmp off


	-- get existing deposit usage
	set identity_insert tblpotentialregisterpaymentdeposittmp on 

	insert tblpotentialregisterpaymentdeposittmp (RegisterPaymentDepositID,RegisterPaymentID,DepositRegisterID,Amount)
	select RegisterPaymentDepositID,RegisterPaymentID,DepositRegisterID,rpd.Amount
	from tblregisterpaymentdeposit rpd 
	join tblpotentialregistertmp r on r.registerid = rpd.depositregisterid 
	where rpd.voided = 0
	and rpd.bounced = 0

	set identity_insert tblpotentialregisterpaymentdeposittmp off


	-- creating payments temp table
	select *, -1 [commrecid], -1 [entrytypeid], -1 [companyid]
	into #commpaytmp
	from tblcommpay
	where 1=0


	-- reindex temp tables now that they're populated
	DBCC DBREINDEX('tblpotentialregistertmp',' ',90) WITH NO_INFOMSGS
	DBCC DBREINDEX('tblpotentialregisterpaymenttmp',' ',90) WITH NO_INFOMSGS
	DBCC DBREINDEX('tblpotentialregisterpaymentdeposittmp',' ',90) WITH NO_INFOMSGS


	-- (1) open and loop all oustanding fees		
	declare cursor_a cursor for
		select
			registerid
		from
			tblpotentialregistertmp
		where
			fee = 1
			and amount < 0 
			and isfullypaid = 0 
		order by
			clientid desc, entrytypeorder, transactiondate

	open cursor_a
	fetch next from cursor_a into @registerid
	while @@fetch_status = 0
		begin
			-- (2) run payment proc on each fee
			exec stp_PotentialPayFee @registerid
			fetch next from cursor_a into @registerid
		end
	close cursor_a
	deallocate cursor_a


	--save projections for the day
	insert tblpotentialcommpay (companyid, commrecid, entrytypeid, amount, fordate)
	select companyid, commrecid, entrytypeid, sum(amount), @fordate
	from #commpaytmp 
	group by companyid, commrecid, entrytypeid

	insert tblpotentialdeposits (companyid, agencyid, depositcount, amount, fordate)
	select c.companyid, c.agencyid, count(*), sum(amount), @fordate
	from tblpotentialregistertmp r
	join tblclient c on c.clientid = r.clientid
	where r.entrytypeid = 3
		and r.transactiondate = @fordate
		and (r.hold is null or r.hold < @fordate)
	group by c.companyid, c.agencyid


	drop table #commpaytmp

set @Day = @Day + 1

end -- while
 
set nocount off
set ansi_warnings on
GO
 