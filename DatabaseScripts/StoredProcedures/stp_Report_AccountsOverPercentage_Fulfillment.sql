/****** Object:  StoredProcedure [dbo].[stp_Report_AccountsOverPercentage_Fulfillment]    Script Date: 11/19/2007 15:27:38 ******/
DROP PROCEDURE [dbo].[stp_Report_AccountsOverPercentage_Fulfillment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Report_AccountsOverPercentage_Fulfillment]
(
	@hiredate1 datetime = null,
	@hiredate2 datetime = null,
	@percent1 float = null,
	@percent2 float = null,
	@sdabal1 float = 0,
	@sdabal2 float = null,
	@accountbal1 float = null,
	@accountbal2 float = null,
	@clientstatusids varchar(999) = null,
	@clientstatusidsop varchar(5) = '',
	@agencyids varchar(999) = null,
	@agencyidsop varchar(5) = '',
	@accountstatusids varchar(999) = null,
	@accountstatusidsop varchar(5) = null,
	@Assigned bit = null
)

as

create table #tmpAccountStatusIds(AccountStatusID int)
if @accountstatusids is null begin
	insert into #tmpAccountStatusIds select AccountStatusId from tblAccountStatus
end else begin
	exec('insert into #tmpAccountStatusIds select AccountStatusId from tblAccountStatus where ' + @accountstatusidsop + ' AccountStatusId in(' + @accountstatusids + ')')
end

create table #tmpAgencyIds(AgencyId int)
if @agencyids is null begin
	insert into #tmpagencyids select agencyid from tblagency
end else begin
	
	exec('insert into #tmpAgencyIds select agencyid from tblagency where ' + @agencyidsop + ' agencyid in(' + @agencyids + ')')
end

create table #tmpClientStatusIds(ClientStatusId int) 
if @clientstatusids is null begin
	insert into #tmpclientstatusids select clientstatusid from tblclientstatus
end else begin
	exec('insert into #tmpClientStatusIds select clientstatusid from tblclientstatus where ' + @clientstatusidsop + ' clientstatusid in(' + @clientstatusids + ')')
end

select 
	c.clientid,
	balance
into
	#tmpbal
from
	tblclient c inner join
	tblregister r on c.clientid=r.clientid
where 
	r.registerid = (select top 1 registerid from tblregister where tblregister.clientid=r.clientid order by transactiondate desc, registerid desc)
	and balance >= isnull(@sdabal1, balance)
	and balance <= isnull(@sdabal2, balance)
	and	(@assigned is null or (case when c.assignedmediator is null then 0 else 1 end) = @assigned)

select 
	c.clientid,
	c.accountnumber,
	c.created,
	c.agencyid,
	c.currentclientstatusid,
	c.assignedmediator,
	c.primarypersonid
into
	#tmpclient
from 
	tblclient c
where
	agencyid in (select agencyid from #tmpagencyids) and
	c.currentclientstatusid in (select clientstatusid from #tmpclientstatusids) and
	c.created >= isnull(@hiredate1, c.created) and 
	c.created <= isnull(@hiredate2, c.created) 
	and	(@assigned is null or (case when c.assignedmediator is null then 0 else 1 end) = @assigned)

select
	c.*,
	a.currentcreditorinstanceid,
	a.accountid,
	a.currentamount as accountbalance,
	sdabal.balance as sdabalance,
	a.accountstatusid
into
	#tmpClientAccounts
from
	#tmpclient c inner join
	tblaccount a on c.clientid = a.clientid  inner join
	#tmpbal sdabal on c.clientid=sdabal.clientid
where
	(
		a.accountstatusid in (select accountstatusid from #tmpaccountstatusids) or 
		(accountstatusid is null and @accountstatusidsop='not')
	) and
	a.currentamount >= isnull(@accountbal1, a.currentamount) and 
	a.currentamount <= isnull(@accountbal2, a.currentamount) and
	isnull(a.currentamount * @percent1, sdabal.balance) <= sdabal.balance and
	isnull(a.currentamount * @percent2, sdabal.balance) >= sdabal.balance
	and	(@assigned is null or (case when c.assignedmediator is null then 0 else 1 end) = @assigned)


select
	distinct(c.clientid),
	c.assignedmediator,
	p.lastname,
	c.sdabalance,
	count(c.accountid) as accounts
from
	#tmpclientaccounts c inner join
	tblcreditorinstance ci on c.currentcreditorinstanceid=ci.creditorinstanceid inner join
	tblcreditor cr on ci.creditorid=cr.creditorid inner join
	tblstate crstate on cr.stateid=crstate.stateid inner join
	tblperson p on c.primarypersonid=p.personid
group by
	c.clientid,
	c.assignedmediator,
	p.lastname,
	c.sdabalance

drop table #tmpbal
drop table #tmpclient
drop table #tmpclientstatusids
drop table #tmpagencyids
drop table #tmpClientAccounts
drop table #tmpAccountStatusIds
GO
