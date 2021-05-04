IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_settlementresolution')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_settlementresolution
	END

GO

CREATE Procedure stp_settlementimport_reports_settlementresolution
	(
		@year int
	)
AS
BEGIN
	declare @tblData table(YearNumber int,MonthNumber int,[MonthName] varchar(50)
	,[Rejected/Cancelled: By Client] varchar(50),[Rejected/Cancelled: By Mgr] varchar(50),[Rejected/Cancelled: By Atty] varchar(50),[Rejected/Cancelled: By Creditor] varchar(50)
	,[Expired: No SIF] varchar(50),[Expired: In Mgr Queue] varchar(50),[Expired: No Client Approval] varchar(50),[Expired: In Accounting] varchar(50),[Expired: No Deposit] varchar(50),[Expired: No LC/SA Approval] varchar(50)
	,[Paid: Matter] varchar(50),[Paid: Manual] varchar(50),[Paid: Total] varchar(50)
	)

	insert into @tblData 
	select 
		[YearNumber] = year(s.created)
		,[MonthNumber]=month(s.created)
		, [MonthName]=datename(month,s.created)
		,[Rejected/Cancelled: By Client] = sum(case when MatterStatusCodeId in(25,42) and settpaid.registerid is null then 1 else 0 end)
		,[Rejected/Cancelled: By Mgr] = sum(case when (MatterStatusCodeId = 33 or (s.matterid is null and so.rejected is not null)) and settpaid.registerid is null then 1 else 0 end)
		,[Rejected/Cancelled: By Atty] = sum(case when s.recommend = 0 then 1 else 0 end)
		,[Rejected/Cancelled: By Creditor] =  sum(case when MatterStatusCodeId = 44 then 1 else 0 end)
		,[Expired: No SIF] = sum(case when MatterStatusCodeId = 43 or ((datediff(day,s.settlementduedate,getdate())*-1) < 0 and s.matterid is null and settpaid.registerid is null and rd.settlementid is not null) then 1 else 0 end)
		,[Expired: In Mgr Queue] = sum(case when (so.settlementid is not null and so.approved is null and so.rejected is null and s.matterid is null and se.settlementid is not null) or (so.settlementid is not null and (datediff(d,so.rejected,s.settlementduedate)<0 or datediff(d,so.approved,s.settlementduedate)<0)) then 1 else 0 end)
		,[Expired: No Client Approval] = 0
		,[Expired: In Accounting] = 0
		,[Expired: No Deposit] = 0
		,[Expired: No LC/SA Approval] = 0
		,[Paid: Matter] = sum(case when sub.mattersubstatus is not null and MatterStatusCodeId = 37 and settpaid.registerid is not null then 1 else 0 end) 
		,[Paid: Manual] = sum(case when settpaid.registerid is not null and s.matterid is null then 1 else 0 end) 
		,[Paid: Total] = 0
	from tblsettlements s with(nolock)
	left join vwClientNextDepositSchedule vcnd with(nolock)  on vcnd.clientid = s.clientid
	left join (select settlementid,max(settlementstatusid)[stepid] from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 5) as rd on rd.settlementid = s.settlementid
	left join (select settlementid from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 9) as se on se.settlementid = s.settlementid
	left join tblsettlements_overs so with(nolock) on so.settlementid = s.settlementid
	left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
	left join tblmatter m with(nolock) on s.matterid = m.matterid
	left join tblmattersubstatus sub on m.mattersubstatusid = sub.mattersubstatusid 
	where status = 'a' and active = 1
	and s.created between convert(varchar(10),dateadd(d,-day(getdate()-1),dateadd(yy,-1,getdate())),101) and convert(varchar(10),dateadd(d,-day(getdate()),dateadd(m,1,getdate())),101)
	group by year(s.created),month(s.created),datename(month,s.created)


	select 
		[YearNumber]
		,MonthNumber	
		,[MonthName]
		,[Rejected/Cancelled: By Client] 
		,[Rejected/Cancelled: By Mgr] 
		,[Rejected/Cancelled: By Atty]
		,[Rejected/Cancelled: By Creditor] 
		,[Expired: No SIF] 
		,[Expired: In Mgr Queue] 
		,[Expired: No Client Approval] 
		,[Expired: In Accounting] 
		,[Expired: No Deposit] 
		,[Expired: No LC/SA Approval] 
		,[Paid: Matter] 
		,[Paid: Manual] 
		,[Paid: Total] = cast([Paid: Matter] as int) + cast([Paid: Manual] as int)
	from 
		@tblData 
	order by 
		yearnumber desc, monthnumber desc

END

GO


GRANT EXEC ON stp_settlementimport_reports_settlementresolution TO PUBLIC

GO


