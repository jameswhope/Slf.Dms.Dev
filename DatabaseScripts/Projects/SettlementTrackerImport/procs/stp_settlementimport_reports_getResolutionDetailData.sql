 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getResolutionDetailData')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getResolutionDetailData
	END

GO

CREATE Procedure stp_settlementimport_reports_getResolutionDetailData
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

	if @filter ='Rejected/Cancelled: By Client'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
			where status = 'a' and active = 1
				and year(s.created) = @year
				and month(s.created) = @month
				and (m.MatterStatusCodeId in(25,42) and settpaid.registerid is null)
			order by s.created
			option (fast 500)
		END
	if @filter ='Rejected/Cancelled: By Mgr'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
				left join tblsettlements_overs so with(nolock) on so.settlementid = s.settlementid
			where status = 'a' and active = 1
				and year(s.created) = @year
				and month(s.created) = @month
				and (m.MatterStatusCodeId = 33 or (s.matterid is null and so.rejected is not null)) and settpaid.registerid is null 
			order by s.created
			option (fast 500)
		END
	if @filter ='Rejected/Cancelled: By Atty'
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
				and s.recommend = 0
			order by s.created
			option (fast 500)
		END
	if @filter ='Rejected/Cancelled: By Creditor'
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
				and (m.MatterStatusCodeId = 44)
			order by s.created
			option (fast 500)
		END
	if @filter ='Expired: No SIF'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
				left join (select settlementid,max(settlementstatusid)[stepid] from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 5) as rd on rd.settlementid = s.settlementid
			where status = 'a' and active = 1
				and year(s.created) = @year
				and month(s.created) = @month
				and (m.MatterStatusCodeId = 43 or ((datediff(day,s.settlementduedate,getdate())*-1) < 0 and s.matterid is null and settpaid.registerid is null and rd.settlementid is not null))
			order by s.created
			option (fast 500)
		END
	if @filter ='Expired: In Mgr Queue'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join (select settlementid from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 9) as se on se.settlementid = s.settlementid
				left join tblsettlements_overs so with(nolock) on so.settlementid = s.settlementid
			where status = 'a' and active = 1
				and year(s.created) = @year
				and month(s.created) = @month
				and ((so.settlementid is not null and so.approved is null and so.rejected is null and s.matterid is null and se.settlementid is not null) or (so.settlementid is not null and (datediff(d,so.rejected,s.settlementduedate)<0 or datediff(d,so.approved,s.settlementduedate)<0)) )
			order by s.created
			option (fast 500)
		END		
/*
	if @filter ='Expired: No Client Approval'
	if @filter ='Expired: In Accounting'
	if @filter ='Expired: No Deposit'
	if @filter ='Expired: No LC/SA Approval'
*/
	if @filter ='Paid: Matter'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
				left join tblmattersubstatus sub on m.mattersubstatusid = sub.mattersubstatusid 
			where status = 'a' and active = 1
				and year(s.created) = @year
				and month(s.created) = @month
				and (sub.mattersubstatus is not null and m.MatterStatusCodeId = 37 and settpaid.registerid is not null)
			order by s.created
			option (fast 500)
		END
	if @filter ='Paid: Manual'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
			where status = 'a' and active = 1
				and year(s.created) = @year
				and month(s.created) = @month
				and (settpaid.registerid is not null and s.matterid is null )
			order by s.created
			option (fast 500)
		END
	if @filter ='Paid: Total'
		BEGIN
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
				left join tblmattersubstatus sub on m.mattersubstatusid = sub.mattersubstatusid 
			where status = 'a' and active = 1
				and year(s.created) = @year
				and month(s.created) = @month
				and (settpaid.registerid is not null and s.matterid is null) 
			order by s.created
			option (fast 500)
			
			insert into @tblData
			select s.settlementid
			from tblsettlements s with(nolock)
				inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
				inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
				inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
				left join tblmatter m with(nolock) on s.matterid = m.matterid
				left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
				left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
				left join tblmattersubstatus sub on m.mattersubstatusid = sub.mattersubstatusid 
			where status = 'a' and active = 1
				and year(s.created) = @year
				and month(s.created) = @month
				and (sub.mattersubstatus is not null and m.MatterStatusCodeId = 37 and settpaid.registerid is not null)
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
		,s.settlementduedate, [Paid]=settpaid.transactiondate
	from tblsettlements s with(nolock) 
		inner join tblclient c with(nolock) on s.clientid  = c.clientid
		inner join tblperson p with(nolock) on p.personid = c.primarypersonid
		inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid
		inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid
		inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid
		inner join tbluser uc with(nolock) on uc.userid = s.createdby
		left join tblmatter m with(nolock) on s.matterid = m.matterid
		left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid
		left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
		inner join @tblData td on td.settid = s.settlementid
	order by s.created
	option (fast 500)
END


GO


GRANT EXEC ON stp_settlementimport_reports_getResolutionDetailData TO PUBLIC

GO


