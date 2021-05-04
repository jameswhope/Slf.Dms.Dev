IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_CloseMattersDue')
	BEGIN
		DROP  Procedure  stp_NonDeposit_CloseMattersDue
	END

GO

CREATE Procedure stp_NonDeposit_CloseMattersDue
@userid int
AS
BEGIN

Declare cursor_mattersdue Cursor For
select m.matterid 
from tblmatter m
inner join tblnondeposit n on n.matterid = m.matterid
inner join 
(select mtaskid = max(mt.taskid), mt.matterid from tblmattertask mt group by mt.matterid)  mtt on mtt.matterid = m.matterid
inner join tbltask t on t.taskid = mtt.mtaskid
where m.mattertypeid = 5
and m.matterstatusid in (1,3)
and t.due < GetDate()

declare @matterid int
 
Open cursor_mattersdue
Fetch next from cursor_mattersdue into @matterid

While @@Fetch_Status = 0
Begin
	--Close matter
	exec stp_NonDeposit_CloseMatter @matterid, 'ND_NA', 'Closed for Inaction', 'Non deposit matter expired', @userid
	Fetch next from cursor_mattersdue into @matterid
End

Close cursor_mattersdue
Deallocate cursor_mattersdue

END

GO

 
