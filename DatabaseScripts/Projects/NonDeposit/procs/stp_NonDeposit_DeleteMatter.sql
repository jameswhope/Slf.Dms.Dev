IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_DeleteMatter')
	BEGIN
		DROP  Procedure  stp_NonDeposit_DeleteMatter
	END

GO

CREATE Procedure stp_NonDeposit_DeleteMatter
@MatterId int,
@UserId int
AS
Begin
	declare @nondepositid int set @nondepositid = null
	select @nondepositid = nondepositid from tblnondeposit Where matterid = @matterid 
	
	if @nondepositid is not null
	begin
		exec stp_NonDeposit_RemoveCurrentReplacement @nondepositid, @UserId
	end

	Update tblMatter Set
	IsDeleted = 1
	Where matterid = @matterid
	
	Update tblNonDeposit Set
	Deleted = GetDate(),
	DeletedBy = @UserId
	Where matterid = @matterid

End

GO

 

