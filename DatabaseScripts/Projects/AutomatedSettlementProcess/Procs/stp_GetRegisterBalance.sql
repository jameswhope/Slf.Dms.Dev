IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetRegisterBalance')
	BEGIN
		DROP  Procedure  stp_GetRegisterBalance
	END
GO

create procedure stp_GetRegisterBalance
(
	@clientid int
)
as
BEGIN
	-- replaces stp_negotiations_getRegisterBalance

	declare @tblreg table(amount money, eid int,bounce datetime,void datetime,hold datetime,[clear] datetime)
	declare @FundsOnHold money


	insert into @tblreg 
	select amount,entrytypeid,bounce,void,hold,[clear]
	from tblregister with(nolock)
	where clientid = @clientid order by transactiondate desc


	delete from @tblreg where eid = 3 and hold > getdate() and [clear] is null
	delete from @tblreg where bounce is not null
	delete from @tblreg where void is not null
	delete from @tblreg where eid = -2


	-- funds are on hold in between the time the client approves a settlement and the settlement gets paid,
	-- after that the payment gets reflected directly in the SDA
	select @FundsOnHold = isnull(sum(s.settlementamtbeingsent),0)
	from tbltask t
	join tblmattertask mt on mt.taskid = t.taskid
	join tblmatter m on m.matterid = mt.matterid and m.clientid = @clientid
	join tblsettlements s on s.matterid = m.matterid and s.settlementamtbeingsent > 0 and s.active = 1
	join tblcreditorinstance ci on ci.creditorinstanceid = m.creditorinstanceid
	join tblaccount a on a.accountid = ci.accountid
	join tblaccountstatus at on at.accountstatusid = a.accountstatusid and at.accountstatusid not in (54,55) -- Settled, Removed
	where t.tasktypeid = 72 -- Client Approval
	and t.resolved is not null


	select 
	isnull(sum(case when eid IN(3,-2) then amount else 0 end),0)[TotalDeposits] 
	,isnull(-sum(case when not eid IN(3,-2) then amount else 0 end),0)[TotalWithdrawls] 
	,isnull(case when sum(case when eid IN(3,-2) then amount else 0 end)+sum(case when not eid IN(3,-2) then amount else 0 end) < 0 then 0 else sum(case when eid IN(3,-2) then amount else 0 end)+sum(case when not eid IN(3,-2) then amount else 0 end)end,0)[SDABalance] 
	,isnull(case when sum(case when eid IN(3,-2) then amount else 0 end)+sum(case when not eid IN(3,-2) then amount else 0 end) > 0 then 0 else -(sum(case when eid IN(3,-2) then amount else 0 end)+sum(case when not eid IN(3,-2) then amount else 0 end))end,0)[PFOBalance] 
	,@FundsOnHold [FundsOnHold]
	from @tblreg
	
END 
go