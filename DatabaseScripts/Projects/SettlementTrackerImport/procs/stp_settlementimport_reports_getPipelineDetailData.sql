IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getPipelineDetailData')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getPipelineDetailData
	END

GO

CREATE Procedure stp_settlementimport_reports_getPipelineDetailData
(
		@year int,
		@month int,
		@filter varchar(200)
	)

AS
BEGIN
/*
	declare @year int
	declare @month int
	declare @filter varchar(100)

	set @year = 2010
	set @month = 12
	set @filter = 'offers'
*/
	declare @tblData table(settID int)

	if @filter ='offers'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
			where status = 'a' and active = 1
				and year(s.created) = @year
				and month(s.created) = @month
			order by s.created
			option (fast 500)
		END
	if @filter ='submitted: with funds'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
			where status = 'a' and active = 1
				and year(s.created) = @year
				and month(s.created) = @month
				and availsda >= settlementamount
			order by s.created
			option (fast 500)
		END

	if @filter ='submitted: future deposit'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join vwClientNextDepositSchedule vcnd with(nolock)  on vcnd.clientid = s.clientid
			where status = 'a' and active = 1
				and year(s.created) = @year
				and month(s.created) = @month
				and (availsda + vcnd.nextdepositamount >= settlementamount and availsda < settlementamount)
			order by s.created
			option (fast 500)
		END
	if @filter ='submitted: shortage'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				inner join tbluser uc with(nolock) on uc.userid = s.createdby
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join vwClientNextDepositSchedule vcnd with(nolock)  on vcnd.clientid = s.clientid
			where status = 'a' and active = 1 and year(s.created) = @year and month(s.created) = @month
				and (availsda < settlementamount and availsda + vcnd.nextdepositamount < settlementamount)
			order by s.created
			option (fast 500)
		END
	if @filter ='waiting: sif'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				inner join tbluser uc with(nolock) on uc.userid = s.createdby
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join (select settlementid,max(settlementstatusid)[stepid] from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 5) as rd on rd.settlementid = s.settlementid
			where status = 'a' and active = 1 and year(s.created) = @year and month(s.created) = @month
				and (s.matterid is null and datediff(d,s.settlementduedate,getdate())*-1>= 0 and rd.stepid = 5)
			order by s.created
			option (fast 500)
		END
	if @filter ='waiting: mgr'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				inner join tbluser uc with(nolock) on uc.userid = s.createdby
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join tblsettlements_overs so with(nolock) on so.settlementid = s.settlementid
			where status = 'a' and active = 1 and year(s.created) = @year and month(s.created) = @month
				and (m.MatterStatusCodeId = 27 or (so.settlementid is not null and so.approved is null and so.rejected is null and s.matterid is null))
			order by s.created
			option (fast 500)
		END
	if @filter ='waiting: client'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				inner join tbluser uc with(nolock) on uc.userid = s.createdby
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
			where status = 'a' and active = 1 and year(s.created) = @year and month(s.created) = @month
				and (m.MatterStatusCodeId = 23 or (s.matterid is null and (isnull(isclientstipulation,0)=1 or isnull(ispaymentarrangement,0)=1) and datediff(d,s.settlementduedate,getdate())*-1>= 0 and settpaid.registerid is null))
			order by s.created
			option (fast 500)
		END		
	if @filter ='waiting: accounting'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				inner join tbluser uc with(nolock) on uc.userid = s.createdby
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
			where status = 'a' and active = 1 and year(s.created) = @year and month(s.created) = @month
				and (m.MatterStatusCodeId in(36,38) and settpaid.registerid is null)
			order by s.created
			option (fast 500)
		END		
	if @filter ='waiting: deposit'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				inner join tbluser uc with(nolock) on uc.userid = s.createdby
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
				left join vwClientNextDepositSchedule vcnd with(nolock)  on vcnd.clientid = s.clientid
			where status = 'a' and active = 1 and year(s.created) = @year and month(s.created) = @month
				and (m.MatterStatusCodeId in(35,39,40) and settpaid.registerid is null and (availsda < settlementamount and availsda + vcnd.nextdepositamount < settlementamount))
			order by s.created
			option (fast 500)
		END		
	if @filter ='waiting: lc/sa approval'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				inner join tbluser uc with(nolock) on uc.userid = s.createdby
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
			where status = 'a' and active = 1 and year(s.created) = @year and month(s.created) = @month
				and m.MatterStatusCodeId = 13
			order by s.created
			option (fast 500)
		END
	if @filter ='processing: chk by phone'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				inner join tbluser uc with(nolock) on uc.userid = s.createdby
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
			where status = 'a' and active = 1 and year(s.created) = @year and month(s.created) = @month
				and (m.MatterStatusCodeId = 39 and settpaid.registerid is null)
			order by s.created
			option (fast 500)
		END
	if @filter ='processing: email'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				inner join tbluser uc with(nolock) on uc.userid = s.createdby
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
			where status = 'a' and active = 1 and year(s.created) = @year and month(s.created) = @month
				and (m.MatterStatusCodeId = 40 and settpaid.registerid is null)
			order by s.created
			option (fast 500)
		END					
	if @filter ='processing: print'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				inner join tbluser uc with(nolock) on uc.userid = s.createdby
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
			where status = 'a' and active = 1 and year(s.created) = @year and month(s.created) = @month
				and (m.MatterStatusCodeId = 35 and settpaid.registerid is null)
			order by s.created
			option (fast 500)
		END		
	select s.settlementid,[ClientAcctNum] = c.accountnumber,[ClientName]=p.firstname + ' ' + p.lastname,[Client CDA Bal]=s.availsda
		,[CreditorName]=cc.name,[CreditorBal]=ci.amount,[SettlementAmt]=s.settlementamount,[SettlementFee]=s.settlementfee
		,[Negotiator]=uc.firstname + ' ' + uc.lastname,[Status]=Isnull(msc.MatterStatusCodeDescr ,'NONE')
		,[Client Stipulation] = case when isnull(s.isclientstipulation ,0)=1 then 'Y' else 'N' end
		,[Payment Arrangement] = case when isnull(s.isPaymentArrangement ,0)=1 then 'Y' else 'N' end
		,[Restrictive Endorsement]=case when isnull(s.IsRestrictiveEndorsement ,0)=1 then 'Y' else 'N' end
		,[LC Approval] = case when s.recommend is null then 'Y' else 'N' end
	from tblsettlements s with(nolock) 
		inner join tblclient c with(nolock) on s.clientid  = c.clientid
		inner join tblperson p with(nolock) on p.personid = c.primarypersonid
		inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
		inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
		inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
		inner join tbluser uc with(nolock) on uc.userid = s.createdby
		left join tblmatter m with(nolock) on s.matterid = m.matterid
		left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
		inner join @tblData td on td.settid = s.settlementid
	order by s.created
	option (fast 500)
END


GO


GRANT EXEC ON stp_settlementimport_reports_getPipelineDetailData TO PUBLIC

GO


