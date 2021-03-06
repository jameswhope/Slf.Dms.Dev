/****** Object:  StoredProcedure [dbo].[stp_Report_AccountsOverPercentage]    Script Date: 11/19/2007 15:27:37 ******/
DROP PROCEDURE [dbo].[stp_Report_AccountsOverPercentage]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Report_AccountsOverPercentage]
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
	@mediator int=null,
	@Assigned bit = null,
	@orderby varchar(255) = 'c.lastname1,c.accountid'
)

as

if not @orderby is null
	set @orderby=' order by ' + @orderby
else
	set @orderby=''

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
	creditorid,
	p.*
into
	#tmpphone
from
	tblcreditorphone cp inner join
	tblphone p on cp.phoneid=p.phoneid
where 
	p.phoneid = (select top 1 cp2.phoneid from tblcreditorphone cp2 where cp2.creditorid = cp.creditorid)

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
	--and (@mediator is null or (@mediator=c.assignedmediator))
	--and	(@assigned is null or (case when c.assignedmediator is null then 0 else 1 end) = @assigned)

select 
	c.clientid,
	c.accountnumber,
	c.created,
	c.agencyid,
	c.currentclientstatusid,
	c.assignedmediator,
	prim.firstname as firstname1,
	prim.lastname as lastname1,
	prim.ssn as ssn1,
	prim.personid as personid1,
	sec.firstname as firstname2,
	sec.lastname as lastname2,
	sec.ssn as ssn2,
	sec.personid as personid2
into
	#tmpclient
from 
	(
		select 
			nc.clientid,
			nc.accountnumber,
			nc.created,
			nc.agencyid,
			nc.currentclientstatusid,
			nc.assignedmediator,
			nc.primarypersonid
		from
			tblclient nc
		where
			agencyid in (select agencyid from #tmpagencyids) and
			nc.currentclientstatusid in (select clientstatusid from #tmpclientstatusids) and
			nc.created >= isnull(@hiredate1, nc.created) and 
			nc.created <= isnull(@hiredate2, nc.created) 
			and (@mediator is null or (@mediator=nc.assignedmediator))
			and	
			(
				@assigned is null or 
				(@assigned=1 and not nc.assignedmediator is null) or
				(@assigned=0 and nc.assignedmediator is null)
			)
	) c inner join
	tblPerson as prim ON c.PrimaryPersonId=prim.PersonId LEFT OUTER JOIN
	tblPerson as sec ON sec.PersonId <> c.primarypersonid and sec.clientid=c.clientid


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
	--and (@mediator is null or (@mediator=c.assignedmediator))
	--and (@assigned is null or (case when c.assignedmediator is null then 0 else 1 end) = @assigned)

declare @vperc1 varchar(50)
declare @vperc2 varchar(50)
set @vperc1 = isnull(convert(varchar,@percent1),'null')
set @vperc2 = isnull(convert(varchar,@percent2),'null')

exec('
select
	c.*,
	cr.creditorid,
	ci.creditorinstanceid,
	cr.[name] as creditorname,
	cr.street as creditorstreet,
	cr.street2 as creditorstreet2,
	cr.city as creditorcity,
	cr.zipcode as creditorzip,
	crstate.abbreviation as creditorstate,
	ci.referencenumber as creditorreferencenumber,
	ci.accountnumber as creditoraccountnumber,
	(crphone.AreaCode + crphone.Number + '' '' + isnull(crphone.Extension,'''')) as creditorphone,'
	 + @vperc1 + ' as percent1,'
	 + @vperc2 + ' as percent2
from
	#tmpclientaccounts c inner join
	tblcreditorinstance ci on c.currentcreditorinstanceid=ci.creditorinstanceid inner join
	tblcreditor cr on ci.creditorid=cr.creditorid inner join
	tblstate crstate on cr.stateid=crstate.stateid left outer join
	#tmpphone crphone on cr.creditorid=crphone.creditorid
' 	+ @orderby
)

drop table #tmpphone
drop table #tmpbal
drop table #tmpclient
drop table #tmpclientstatusids
drop table #tmpagencyids
drop table #tmpClientAccounts
drop table #tmpAccountStatusIds
GO
