/****** Object:  StoredProcedure [dbo].[stp_AssignNegotiator]    Script Date: 11/19/2007 15:26:54 ******/
DROP PROCEDURE [dbo].[stp_AssignNegotiator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_AssignNegotiator]
(
	@clientid int
)
as
declare @AutoAssign bit
set @autoassign=(select autoassignmediator from tblclient where clientid=@clientid)
if @autoassign=1 begin
	declare	@hiredate1 datetime
	declare	@hiredate2 datetime
	declare	@percent1 float
	declare	@percent2 float 
	declare	@sdabal1 float 
	declare	@sdabal2 float 
	declare	@accountbal1 float 
	declare	@accountbal2 float 
	declare	@clientstatusids varchar(999)
	declare	@clientstatusidschoice bit
	declare	@agencyids varchar(999)
	declare	@agencyidschoice bit 
	declare	@accountstatusids varchar(999) 
	declare	@accountstatusidschoice bit

	set @hiredate1=(select convert(datetime,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='HireDate1')
	set @hiredate2=(select convert(datetime,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='HireDate2')
	set @percent1=(select convert(float,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='ThresholdPercent1')/100
	set @percent2=(select convert(float,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='ThresholdPercent2')/100
	set @sdabal1=null
	set @sdabal2=null
	set @accountbal1=(select convert(float,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='AccountBalance1')
	set @accountbal2=(select convert(float,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='AccountBalance2')
	set @clientstatusids=(select convert(varchar,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='ClientStatusIDs')
	set @clientstatusidschoice=(select convert(bit,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='ClientStatusChoice')
	set @agencyids=(select convert(varchar,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='AgencyIDs')
	set @agencyidschoice=(select convert(bit,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='AgencyChoice')
	set @accountstatusids=(select convert(varchar,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='AccountStatusIDs')
	set @accountstatusidschoice=(select convert(bit,[value]) from tblrulenamevalue where ruletypeid=1 and [name]='AccountStatusChoice')

	declare	@clientstatusidsop varchar(10)
	set @clientstatusidsop = case when @clientstatusidschoice=1 then '' else 'not' end
	declare	@agencyidsop varchar(10)
	set @agencyidsop = case when @agencyidschoice=1 then '' else 'not' end
	declare	@accountstatusidsop varchar(10)
	set @accountstatusidsop = case when @accountstatusidschoice=1 then '' else 'not' end

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

	if exists (
		select 
			c.clientid
		from
			tblclient c inner join
			tblaccount a on c.clientid = a.clientid  inner join
			tblregister sdabal on c.clientid=sdabal.clientid
		where
			c.agencyid in (select agencyid from #tmpagencyids) 
			and c.currentclientstatusid in (select clientstatusid from #tmpclientstatusids) 
			and a.accountstatusid in (select accountstatusid from #tmpaccountstatusids) 
			and sdabal.registerid = (select top 1 registerid from tblregister where tblregister.clientid=sdabal.clientid order by transactiondate desc, registerid desc)
			and sdabal.balance >= isnull(@sdabal1, sdabal.balance)
			and sdabal.balance <= isnull(@sdabal2, sdabal.balance)
			and c.created >= isnull(@hiredate1, c.created) 
			and c.created <= isnull(@hiredate2, c.created) 
			and a.currentamount >= isnull(@accountbal1, a.currentamount) 
			and a.currentamount <= isnull(@accountbal2, a.currentamount) 
			and isnull(a.currentamount * @percent1, sdabal.balance) <= sdabal.balance 
			and isnull(a.currentamount * @percent2, sdabal.balance) >= sdabal.balance
			and c.clientid=@clientid
	) begin
		declare @lastname varchar(2)
		set @lastname=(select lastname from tblclient c inner join tblperson p on c.primarypersonid=p.personid and c.clientid=@clientid)
		declare @userid int
		set @userid = (select userid from tblrulenegotiation where @lastname >= rangestart and @lastname <= rangeend)

		update tblclient set assignedmediator=@userid where clientid=@clientid
		print 'client assigned to negotiator ' + convert(varchar,@userid);

	end else begin
		update tblclient set assignedmediator=null where clientid=@clientid
		print 'client unassigned from negotiator'
	end
	drop table #tmpagencyids
	drop table #tmpclientstatusids
	drop table #tmpaccountstatusids
end else begin
	print 'client non-existant or has auto-assign mediator set to off'
end
GO
