IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_MapAdditionalReplacement')
	BEGIN
		DROP  Procedure  stp_NonDeposit_MapAdditionalReplacement
	END

GO

CREATE Procedure stp_NonDeposit_MapAdditionalReplacement
@userid int
AS
BEGIN
 	Declare @depositamount money
	Declare @registerid int
	Declare @matterid int
	Declare @replacementid int
	Declare @note varchar(max)
	
	Declare cursor_replacement Cursor For
	Select distinct rp.replacementid, r.registerid, r.amount, n.matterid 
	from tblNonDepositReplacement rp 
	inner join tbladhocach a on a.adhocachid = rp.adhocachid
	inner join tblregister r on r.registerid = a.registerid
	inner join tblnondeposit n on rp.replacementid = n.currentreplacementid
	Where r.bounce is null and r.void is null
	and r.registerid not in (select r1.registerid from tblNonDepositReplacementRegisterXref r1)
	--and (m.matterstatusid in (1,3)
	
	Open cursor_replacement
	Fetch next from cursor_replacement into @replacementid, @registerid,  @depositamount, @matterid

	While @@Fetch_Status = 0
	Begin
		--Create association
		insert into tblNonDepositReplacementRegisterXref(replacementid,registerid,amount,createdby)
		values (@replacementid, @registerid, @depositamount, @userid)
		--Get and closed the replacements as collected
		--close matter
		select @note = 'Replacement Deposit Collected for matter ' + convert(varchar, @matterid)
		exec stp_NonDeposit_CloseMatter @matterid, 'ND_DC', 'Replacement Deposit Collected', @note, @userid
		
		Fetch next from cursor_replacement into @replacementid, @registerid,  @depositamount, @matterid
	End
	
	Close cursor_replacement
	Deallocate cursor_replacement
END


GO



