 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_RemoveCurrentReplacement')
	BEGIN
		DROP  Procedure  stp_NonDeposit_RemoveCurrentReplacement
	END

GO

CREATE Procedure stp_NonDeposit_RemoveCurrentReplacement
@NonDepositId int,
@UserId int
AS
Begin
declare @replacementid int set @replacementid = null
declare @adhocachid int set @adhocachid = null
declare @registerid int set @registerid = null

select @replacementid = n.currentreplacementid, @adhocachid = r.adhocachid 
from tblnondepositreplacement r
inner join tblnondeposit n on n.currentreplacementid = r.replacementid
where n.nondepositid = @nondepositid

if @adhocachid is not null
begin
	select @registerid=registerid from tbladhocach where adhocachid = @adhocachid
	if @registerid is null
	begin
		--do not delete adhoc if it was collected
		delete from tbladhocach where adhocachid = @adhocachid and registerid is null
		select @adhocachid = null
	end
end

if @replacementid is not null
begin
	update tblnondepositreplacement set
	closed = 1,
	AdHocAChId = @adhocachid,
	lastmodified = getdate(),
	lastmodifiedby = @userid
	where replacementid = @replacementid
	
	update tblnondeposit set
	currentreplacementid = null,
	lastmodified = getdate(),
	lastmodifiedby = @userid
	where nondepositid = @nondepositid
end

End
	
GO
