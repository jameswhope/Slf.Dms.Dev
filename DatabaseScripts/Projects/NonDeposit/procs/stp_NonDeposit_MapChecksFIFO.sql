IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_MapChecksFIFO')
	BEGIN
		DROP  Procedure  stp_NonDeposit_MapChecksFIFO
	END

GO

CREATE Procedure stp_NonDeposit_MapChecksFIFO
@userid int
AS
BEGIN

--Problem. It wont assign a check that bounces before the scheduled deposit is created
-- Or we create the scheduled deposit on check arriving or we do it if non-assigned check bounces
-- Or we assign bounced checks to new scheduled if checks no assigned to planned deposits

--Get all not assigned checks
Declare cursor_plandeposit Cursor For
Select r.registerid, r.clientid, r.amount, r.created from tblregister r
left join tblPlannedDepositRegisterXref x on r.registerid = x.registerid
left join tblNonDepositReplacementRegisterXref y on r.registerid = y.registerid
where r.entrytypeid = 3
and r.void is null 
and r.bounce is null
and r.checknumber is not null
and r.created >= cast('12/01/2010' as datetime) 
--and r.created >= dateadd(d,-10, getdate()) 
and x.registerid is null
and y.registerid is null
order by r.registerid

--Start assigning checks using FIFO
--For each check. 
Declare @clientid int
Declare @depositamount money
Declare @transactiondate datetime
Declare @registerid int
Declare @matterid int
Declare @replacementid int
Declare @nondepositid int
Declare @planid int
declare @note varchar(max)

Open cursor_plandeposit
Fetch next from cursor_plandeposit into @registerid, @clientid, @depositamount, @transactiondate

While @@Fetch_Status = 0
Begin
	
	select @planid = null, @matterid = null, @replacementid = null, @nondepositid = null
	--Assign first to Non-Deposit
	--Get all non deposit open matters
	Select top 1 @matterid = m.matterid, @nondepositid = n.nondepositid, @replacementid = n.currentreplacementid, @planid = n.planid from tblmatter m
	inner join tblnondeposit n on n.matterid = m.matterid
	left join tblnondepositreplacement r on n.currentreplacementid = r.replacementid
	Where m.clientid = @clientid
	and m.matterstatusid not in (2,4)
	and r.adhocachid is null
	order by m.createddatetime

	--For each matterid. Assign check. Do not do money allocation until we are tasked to do so.
	if @matterid is not null
	begin
		if @replacementid is null
		begin
			-- create replacement id
			exec @replacementid = stp_NonDeposit_InsertNonDepositReplacement @nondepositid, @transactionDate, @depositamount, null, @userid
		end		
		
		-- relate replacement id with registerid 
		insert into tblNonDepositReplacementRegisterXref(ReplacementId, RegisterId, Amount, Created, CreatedBy)
		values (@replacementid, @registerid, @depositamount, getdate(), @userid)

		-- Allocate non deposit with scheduled deposit
		if @planid is not null
		begin
			insert Into tblPlannedDepositRegisterXref(PlanId, RegisterId, Amount, NonDepositReplacementId, CreatedBy)
			values (@planid, @registerid, @depositamount, @replacementId, @userid)
		end
		--close matter
		select @note = 'Replacement Deposit Collected for matter ' + convert(varchar, @matterid)
		exec stp_NonDeposit_CloseMatter @matterid, 'ND_DC', 'Replacement Deposit Collected', @note, @userid
	end
	else 
	begin
		--assign to next scheduled deposit if possible 
		--or Assing to current scheduled for month if already passed
		--Get unassinged planned check that does not have a non deposit matter and has no assigned check
		select top 1 @planId = p.planid from tblplanneddeposit p
		left join tblPlannedDepositRegisterXref x on x.planid = p.planid
		left join tblNonDeposit n on n.planid = p.planid
		where  p.clientid = @clientid
		and p.deposittype = 'Check'
		and x.registerid is null
		and n.nondepositid is null
		and p.ZeroAmountRule = 0
		order by p.createddate desc
		
		if @planid is not null
		begin
			--assing check to that plan
			insert Into tblPlannedDepositRegisterXref(PlanId, RegisterId, Amount, NonDepositReplacementId, Created, CreatedBy)
			values (@planid, @registerid, @depositamount, null, Getdate(), @userid)
		end
	end

	Fetch next from cursor_plandeposit into @registerid, @clientid, @depositamount, @transactiondate
End

Close cursor_plandeposit
Deallocate cursor_plandeposit


END

