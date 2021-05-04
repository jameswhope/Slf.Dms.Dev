IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_AddCreditorValidationTasks')
	BEGIN
		DROP  Procedure  stp_AddCreditorValidationTasks
	END
GO

create procedure stp_AddCreditorValidationTasks
(
	@creditorid int,
	@userid int
)
as

/*  
	Removed 9/17/10 by john - we're only creating tasks that relate to matters now. All unresolved
	task type 13's will be resolved.

-- get clients using this now validated creditor, if they have no other pending validations
-- create a task notifying them that they can resolve

-- note: run this proc just before creditor is validated in case validation is to use existing

select distinct a.clientid
into #clients1
from tblcreditorinstance ci
join tblaccount a on a.currentcreditorinstanceid = ci.creditorinstanceid
where ci.creditorid = @creditorid

declare cur cursor for
	select a.clientid, cl.currentclientstatusid, ci.lastmodifiedby
	from tblcreditorinstance ci
	join tblaccount a on a.currentcreditorinstanceid = ci.creditorinstanceid
	join #clients1 c on c.clientid = a.clientid
	join tblcreditor cr on cr.creditorid = ci.creditorid
	join tblclient cl on cl.clientid = c.clientid
	where ci.creditorid <> @creditorid
	group by a.clientid, cl.currentclientstatusid, ci.lastmodifiedby
	having sum(case when cr.validated = 0 then 1 else 0 end) = 0

declare @clientid int, @taskid int, @currentclientstatusid int, @lastmodifiedby int

open cur
fetch next from cur into @clientid, @currentclientstatusid, @lastmodifiedby
while @@fetch_status = 0 begin

	if @currentclientstatusid < 14 begin
		insert tbltask (tasktypeid,[description],assignedto,due,created,createdby,lastmodified,lastmodifiedby)
		select (case when @currentclientstatusid < 10 then 12 else 13 end), 
			'Creditors validated. You can now resolve this worksheet.',
			@lastmodifiedby, getdate(), getdate(), @userid, getdate(), @userid
			
		select @taskid = scope_identity()
		
		insert tblclienttask (clientid,taskid,created,createdby,lastmodified,lastmodifiedby)
		values (@clientid,@taskid,getdate(),@userid,getdate(),@userid)
	end

	fetch next from cur into @clientid, @currentclientstatusid, @lastmodifiedby
end

close cur
deallocate cur
drop table #clients1*/
