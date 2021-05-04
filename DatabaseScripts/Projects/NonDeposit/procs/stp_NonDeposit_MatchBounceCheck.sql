IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_MatchBounceCheck')
	BEGIN
		DROP  Procedure  stp_NonDeposit_MatchBounceCheck
	END

GO

CREATE Procedure stp_NonDeposit_MatchBounceCheck
@userid int
AS
Begin
	--Map bounced checks with planned deposits if there is a bounced check not assigned to a planned deposit
	--and there is a planned deposit without a check
	--(1) Get planned deposits with no checks
	declare @clientid int
	declare @planid int
	declare @registerid int
	declare @depositamount money
	
	Declare cursor_plandeposit Cursor For
	select p.planid, clientid from tblplanneddeposit p
	left join tblPlannedDepositRegisterXref x on p.planid = x.planid
	where p.deposittype = 'Check' 
	and p.expecteddepositamount > 0
	and x.planid is null
	order by p.scheduleddate 
	
	Open cursor_plandeposit
	Fetch next from cursor_plandeposit into @planid, @clientid 
	
	While @@Fetch_Status = 0
	Begin
		select @registerid = null, @depositamount = null

			--(2) For each planid id get non associated bounced deposits (check only)
		Select top 1 @registerid = r.registerId, @depositamount = r.amount
		from tblregister r
		left join tblPlannedDepositRegisterXref x on r.registerid = x.registerid
		where r.clientid = @clientid 
		and r.entrytypeid = 3
		--and r.bounce >= dateadd(d,-10, getdate()) 
		and r.bounce >= '12/01/2010' 
		and r.checknumber is not null
		and x.registerid is null
		order by r.created
	
		if @registerid is not null
		begin
			--(3) relate planid and registerid
			insert into tblPlannedDepositRegisterXref(PlanId, RegisterId, Amount, NonDepositReplacementId, Created, CreatedBy)
			Values (@planId, @registerid, @depositamount, null, getdate(), @userid)
		end
	
		Fetch next from cursor_plandeposit into @planid, @clientid 
	End

	Close cursor_plandeposit
	Deallocate cursor_plandeposit

End
