IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_ReOpenMatterForMissedReplacement')
	BEGIN
		DROP  Procedure  stp_NonDeposit_ReOpenMatterForMissedReplacement
	END

GO

CREATE Procedure stp_NonDeposit_ReOpenMatterForMissedReplacement
(
	@date datetime,
	@userid int 
	 
)
AS
BEGIN

	Declare cursor_nondeposit Cursor For
	select distinct m.matterid
	from tblnondeposit n
	inner join tblmatter m on m.matterid = n.matterid
	inner join tblnondepositreplacement r on n.currentreplacementid = r.replacementid
	and r.adhocachid is null --is check
	and r.closed = 0 --replacement not closed
	and m.matterstatusid not in (2,4) --matter not closed
	and r.replacementid not in (Select r1.replacementid from tblnondepositreplacementregisterxref r1)
	and convert(varchar(10), r.depositdate, 101) =  convert(varchar(10), @date, 101)
	
	declare @matterid int

	Open cursor_nondeposit
	Fetch next from cursor_nondeposit into @matterid

	While @@Fetch_Status = 0
	Begin
	--Reopen matter
		exec stp_NonDeposit_ReopenMatter @MatterId, 1, @date, null, @userid
		Fetch next from cursor_nondeposit into @matterid
	End

	Close cursor_nondeposit
	Deallocate cursor_nondeposit

END

GO


