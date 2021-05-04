IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getTaskAnalytics')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getTaskAnalytics
	END

GO

CREATE Procedure stp_settlementimport_reports_getTaskAnalytics
	(
		@year int,
		@month int
	)
AS
BEGIN

	declare @tblr table(rOrder int,MonthNum int,MonthDescr varchar(20),OffersMade varchar(30),[Waiting On SIF] varchar(30),[Waiting on Mgr] varchar(30),[Waiting On Client] varchar(30),[Waiting on Accounting] varchar(30),
	[Waiting in Check By Phone] varchar(30),[Waiting in Process By Email] varchar(30),[Waiting to Print] varchar(30),[PAID: Matter] varchar(30),[PAID: MANUAL] varchar(30),
	[Cancelled: Client] varchar(30),[Rejected: Accounting] varchar(30),[Rejected: Client] varchar(30),[Rejected: Manager] varchar(30),[Expired] varchar(30),[Other] varchar(30))

	insert into @tblr
	select 1,month(getdate()),'Potential'
	,[Offers Made]=convert(sum(case when active = 1 then s.settlementfee else 0 end),
	,[Waiting On SIF]=sum(case when active = 1 and s.matterid is null and rd.settlementid is not null and (datediff(day,s.settlementduedate,getdate())*-1) >= 0 then s.settlementfee else 0 end)
	,[Waiting on Mgr] = sum(case when active = 1 and MatterStatusCodeId = 27 then s.settlementfee else 0 end)
	,[Waiting On Client] =sum(case when active = 1 and MatterStatusCodeId = 23 then s.settlementfee else 0 end)
	,[Waiting on Accounting] = sum(case when active = 1 and MatterStatusCodeId in(36,38) then s.settlementfee else 0 end)
	,[Waiting in Check By Phone] = sum(case when active = 1 and MatterStatusCodeId = 39 then s.settlementfee else 0 end)
	,[Waiting in Process By Email] = sum(case when active = 1 and MatterStatusCodeId = 40 then s.settlementfee else 0 end)
	,[Waiting to Print] = sum(case when active = 1 and MatterStatusCodeId = 35 then s.settlementfee else 0 end)
	,[PAID: Matter] = sum(case when sub.mattersubstatus is not null and active = 1 and MatterStatusCodeId = 37 and isnull(ispaymentarrangement,0)=0 then s.settlementfee else 0 end) 
	,[PAID: MANUAL] = sum(case when active = 1 and r.amount is not null and s.matterid is null then s.settlementfee else 0 end) 
	,[Cancelled: Client] = sum(case when active = 1 and MatterStatusCodeId = 42 then s.settlementfee else 0 end)
	,[Rejected: Accounting] = sum(case when active = 1 and MatterStatusCodeId = 41 then s.settlementfee else 0 end)
	,[Rejected: Client] = sum(case when active = 1 and MatterStatusCodeId = 25 then s.settlementfee else 0 end)
	,[Rejected: Manager] = sum(case when active = 1 and (MatterStatusCodeId = 33 or (s.matterid is null and so.rejected is not null) )then s.settlementfee else 0 end)
	,[Expired] = sum(case when active = 1 and (MatterStatusCodeId = 43 or (se.settlementid is not null and s.matterid is null )) then s.settlementfee else 0 end)
	,[Other] =sum(case when active = 1 and MatterStatusCodeId = 13 then s.settlementfee else 0 end)
	from tblsettlements s with(nolock) 
	left join tblregister r with(nolock) on s.creditoraccountid = r.accountid and r.entrytypeid = 18 and r.void is null and r.bounce is null 
	left join tblmatter m with(nolock) on s.matterid = m.matterid
	left join tblmattersubstatus sub on m.mattersubstatusid = sub.mattersubstatusid 
	left join (select settlementid from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 5) as rd on rd.settlementid = s.settlementid
	left join (select settlementid from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 9) as se on se.settlementid = s.settlementid
	left join tblSettlements_Overs so with(nolock) on so.settlementid = s.settlementid
	where year(s.created) = @year and month(s.created) = @month and status='a' 
	group by month(s.created),datename(month,s.created)
	order by  month(s.created),datename(month,s.created)

	insert into @tblr
	select 2,month(getdate()),'Expected'
	,[Offers Made]=abs(sum(case when active = 1 then s.SettlementFeeAmtBeingPaid else 0 end))
	,[Waiting On SIF]=abs(sum(case when active = 1 and s.matterid is null and rd.settlementid is not null and (datediff(day,s.settlementduedate,getdate())*-1) >= 0 then s.SettlementFeeAmtBeingPaid else 0 end))
	,[Waiting on Mgr] = abs(sum(case when active = 1 and MatterStatusCodeId = 27 then s.SettlementFeeAmtBeingPaid else 0 end))
	,[Waiting On Client] =abs(sum(case when active = 1 and MatterStatusCodeId = 23 then s.SettlementFeeAmtBeingPaid else 0 end))
	,[Waiting on Accounting] = abs(sum(case when active = 1 and MatterStatusCodeId in(36,38) then s.SettlementFeeAmtBeingPaid else 0 end))
	,[Waiting in Check By Phone] = abs(sum(case when active = 1 and MatterStatusCodeId = 39 then s.SettlementFeeAmtBeingPaid else 0 end))
	,[Waiting in Process By Email] = abs(sum(case when active = 1 and MatterStatusCodeId = 40 then s.SettlementFeeAmtBeingPaid else 0 end))
	,[Waiting to Print] = abs(sum(case when active = 1 and MatterStatusCodeId = 35 then s.SettlementFeeAmtBeingPaid else 0 end))
	,[PAID: Matter] = abs(sum(case when sub.mattersubstatus is not null and active = 1 and MatterStatusCodeId = 37 and isnull(ispaymentarrangement,0)=0 then s.SettlementFeeAmtBeingPaid else 0 end) )
	,[PAID: MANUAL] = abs(sum(case when active = 1 and r.amount is not null and s.matterid is null then s.SettlementFeeAmtBeingPaid else 0 end) )
	,[Cancelled: Client] = abs(sum(case when active = 1 and MatterStatusCodeId = 42 then s.SettlementFeeAmtBeingPaid else 0 end))
	,[Rejected: Accounting] = abs(sum(case when active = 1 and MatterStatusCodeId = 41 then s.SettlementFeeAmtBeingPaid else 0 end))
	,[Rejected: Client] = abs(sum(case when active = 1 and MatterStatusCodeId = 25 then s.SettlementFeeAmtBeingPaid else 0 end))
	,[Rejected: Manager] = abs(sum(case when active = 1 and (MatterStatusCodeId = 33 or (s.matterid is null and so.rejected is not null) )then s.SettlementFeeAmtBeingPaid else 0 end))
	,[Expired] = abs(sum(case when active = 1 and (MatterStatusCodeId = 43 or (se.settlementid is not null and s.matterid is null )) then s.SettlementFeeAmtBeingPaid else 0 end))
	,[Other] = abs(sum(case when active = 1 and MatterStatusCodeId = 13 then s.SettlementFeeAmtBeingPaid else 0 end))
	from tblsettlements s with(nolock) 
	left join tblregister r with(nolock) on s.creditoraccountid = r.accountid and r.entrytypeid = 18 and r.void is null and r.bounce is null 
	left join tblmatter m with(nolock) on s.matterid = m.matterid
	left join tblmattersubstatus sub on m.mattersubstatusid = sub.mattersubstatusid 
	left join (select settlementid from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 5) as rd on rd.settlementid = s.settlementid
	left join (select settlementid from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 9) as se on se.settlementid = s.settlementid
	left join tblSettlements_Overs so with(nolock) on so.settlementid = s.settlementid
	where year(s.created) = @year and month(s.created) = @month and status='a' 
	group by month(s.created),datename(month,s.created)
	order by  month(s.created),datename(month,s.created)

	insert into @tblr
	select 3,month(getdate()),'33/50'
	,[Offers Made]=cast(abs(sum(case when active = 1 and c.SettlementFeePercentage = .33 then 1 else 0 end)) as varchar) + '/' + cast(abs(sum(case when active = 1 and c.SettlementFeePercentage = .5 then 1 else 0 end))  as varchar)
	,[Waiting On SIF]=cast(abs(sum(case when active = 1 and s.matterid is null and rd.settlementid is not null and (datediff(day,s.settlementduedate,getdate())*-1) >= 0 and c.SettlementFeePercentage = .33 then 1 else 0 end)) as varchar) + '/' + cast(abs(sum(case when active = 1 and s.matterid is null and rd.settlementid is not null and (datediff(day,s.settlementduedate,getdate())*-1) >= 0 and c.SettlementFeePercentage = .5 then 1 else 0 end)) as varchar) 
	,[Waiting on Mgr] = cast(abs(sum(case when active = 1 and MatterStatusCodeId = 27 and c.SettlementFeePercentage = .33 then 1 else 0 end)) as varchar) + '/' + cast(abs(sum(case when active = 1 and MatterStatusCodeId = 27 and c.SettlementFeePercentage = .5 then 1 else 0 end)) as varchar)
	,[Waiting On Client] = cast(abs(sum(case when active = 1 and MatterStatusCodeId = 23 and c.SettlementFeePercentage = .33 then 1 else 0 end)) as varchar) + '/' + cast(abs(sum(case when active = 1 and MatterStatusCodeId = 23 and c.SettlementFeePercentage = .5 then 1 else 0 end)) as varchar) 
	,[Waiting on Accounting] = cast(abs(sum(case when active = 1 and MatterStatusCodeId in(36,38) and c.SettlementFeePercentage = .33 then 1 else 0 end)) as varchar) + '/' + cast(abs(sum(case when active = 1 and MatterStatusCodeId in(36,38) and c.SettlementFeePercentage = .5 then 1 else 0 end)) as varchar)
	,[Waiting in Check By Phone] = cast(abs(sum(case when active = 1 and MatterStatusCodeId = 39 and c.SettlementFeePercentage = .33 then 1 else 0 end)) as varchar) + '/' + cast(abs(sum(case when active = 1 and MatterStatusCodeId = 39 and c.SettlementFeePercentage = .5 then 1 else 0 end)) as varchar)
	,[Waiting in Process By Email] = cast(abs(sum(case when active = 1 and MatterStatusCodeId = 40 and c.SettlementFeePercentage = .33 then 1 else 0 end)) as varchar) + '/' + cast(abs(sum(case when active = 1 and MatterStatusCodeId = 40 and c.SettlementFeePercentage = .5 then 1 else 0 end)) as varchar)
	,[Waiting to Print] = cast(abs(sum(case when active = 1 and MatterStatusCodeId = 35 and c.SettlementFeePercentage = .33 then 1 else 0 end)) as varchar) + '/' + cast(abs(sum(case when active = 1 and MatterStatusCodeId = 35 and c.SettlementFeePercentage = .5 then 1 else 0 end)) as varchar)
	,[PAID: Matter] = cast(abs(sum(case when sub.mattersubstatus is not null and active = 1 and MatterStatusCodeId = 37 and isnull(ispaymentarrangement,0)=0 and c.SettlementFeePercentage = .33 then 1 else 0 end) ) as varchar) + '/' + cast(abs(sum(case when sub.mattersubstatus is not null and active = 1 and MatterStatusCodeId = 37 and isnull(ispaymentarrangement,0)=0 and c.SettlementFeePercentage = .5 then 1 else 0 end) ) as varchar)
	,[PAID: MANUAL] = cast(abs(sum(case when active = 1 and r.amount is not null and s.matterid is null and c.SettlementFeePercentage = .33 then 1 else 0 end) ) as varchar) + '/' + cast(abs(sum(case when active = 1 and r.amount is not null and s.matterid is null and c.SettlementFeePercentage = .5 then 1 else 0 end) ) as varchar)
	,[Cancelled: Client] = cast(abs(sum(case when active = 1 and MatterStatusCodeId = 42 and c.SettlementFeePercentage = .33 then 1 else 0 end)) as varchar) + '/' + cast(abs(sum(case when active = 1 and MatterStatusCodeId = 42 and c.SettlementFeePercentage = .5 then 1 else 0 end)) as varchar)
	,[Rejected: Accounting] = cast(abs(sum(case when active = 1 and MatterStatusCodeId = 41 and c.SettlementFeePercentage = .33 then 1 else 0 end)) as varchar) + '/' +  cast(abs(sum(case when active = 1 and MatterStatusCodeId = 41 and c.SettlementFeePercentage = .5 then 1 else 0 end)) as varchar)
	,[Rejected: Client] = cast(abs(sum(case when active = 1 and MatterStatusCodeId = 25 and c.SettlementFeePercentage = .33 then 1 else 0 end)) as varchar) + '/' + cast(abs(sum(case when active = 1 and MatterStatusCodeId = 25 and c.SettlementFeePercentage = .5 then 1 else 0 end)) as varchar) 
	,[Rejected: Manager] = cast(abs(sum(case when active = 1 and (MatterStatusCodeId = 33 or (s.matterid is null and so.rejected is not null) )and c.SettlementFeePercentage = .33 then 1 else 0 end)) as varchar) + '/' + cast(abs(sum(case when active = 1 and (MatterStatusCodeId = 33 or (s.matterid is null and so.rejected is not null) )and c.SettlementFeePercentage = .5 then 1 else 0 end)) as varchar)
	,[Expired] = cast(abs(sum(case when active = 1 and (MatterStatusCodeId = 43 or (se.settlementid is not null and s.matterid is null )) and c.SettlementFeePercentage = .33 then 1 else 0 end)) as varchar) + '/' +  cast(abs(sum(case when active = 1 and (MatterStatusCodeId = 43 or (se.settlementid is not null and s.matterid is null )) and c.SettlementFeePercentage = .5 then 1 else 0 end)) as varchar)
	,[Other] = cast(abs(sum(case when active = 1 and MatterStatusCodeId = 13 and c.SettlementFeePercentage = .33 then 1 else 0 end)) as varchar) + '/' + cast(abs(sum(case when active = 1 and MatterStatusCodeId = 13 and c.SettlementFeePercentage = .5 then 1 else 0 end)) as varchar) 
	from tblsettlements s with(nolock) 
	left join tblregister r with(nolock) on s.creditoraccountid = r.accountid and r.entrytypeid = 18 and r.void is null and r.bounce is null 
	left join tblmatter m with(nolock) on s.matterid = m.matterid
	left join tblmattersubstatus sub on m.mattersubstatusid = sub.mattersubstatusid 
	left join (select settlementid from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 5) as rd on rd.settlementid = s.settlementid
	left join (select settlementid from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 9) as se on se.settlementid = s.settlementid
	left join tblSettlements_Overs so with(nolock) on so.settlementid = s.settlementid
	inner join tblclient c with(nolock) on s.clientid = c.clientid
	where year(s.created) = @year and month(s.created) = @month and status='a' 
	group by month(s.created),datename(month,s.created)
	order by  month(s.created),datename(month,s.created)

	insert into @tblr
	select 4,month(getdate()),'Avg Sett %'
	,[Offers Made]=abs(sum(case when active = 1 then s.settlementpercent else 0 end))/isnull(nullif(abs(sum(case when active = 1 then 1 else 0 end)),0),1)
	,[Waiting On SIF]=abs(sum(case when active = 1 and s.matterid is null and rd.settlementid is not null and (datediff(day,s.settlementduedate,getdate())*-1) >= 0 then s.settlementpercent else 0 end))/isnull(nullif(abs(sum(case when active = 1 and s.matterid is null and rd.settlementid is not null and (datediff(day,s.settlementduedate,getdate())*-1) >= 0 then 1 else 0 end)),0),1)
	,[Waiting on Mgr] = abs(sum(case when active = 1 and MatterStatusCodeId = 27 then s.settlementpercent else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 27 then 1 else 0 end)),0),1)
	,[Waiting On Client] =abs(sum(case when active = 1 and MatterStatusCodeId = 23 then s.settlementpercent else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 23 then 1 else 0 end)),0),1)
	,[Waiting on Accounting] = abs(sum(case when active = 1 and MatterStatusCodeId in(36,38) then s.settlementpercent else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId in(36,38) then 1 else 0 end)),0),1)
	,[Waiting in Check By Phone] = abs(sum(case when active = 1 and MatterStatusCodeId = 39 then s.settlementpercent else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 39 then 1 else 0 end)),0),1)
	,[Waiting in Process By Email] = abs(sum(case when active = 1 and MatterStatusCodeId = 40 then s.settlementpercent else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 40 then 1 else 0 end)),0),1)
	,[Waiting to Print] = abs(sum(case when active = 1 and MatterStatusCodeId = 35 then s.SettlementFeeAmtBeingPaid else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 35 then 1 else 0 end)),0),1)
	,[PAID: Matter] = abs(sum(case when sub.mattersubstatus is not null and active = 1 and MatterStatusCodeId = 37 and isnull(ispaymentarrangement,0)=0 then s.settlementpercent else 0 end))/isnull(nullif(abs(sum(case when sub.mattersubstatus is not null and active = 1 and MatterStatusCodeId = 37 and isnull(ispaymentarrangement,0)=0 then 1 else 0 end)),0),1)
	,[PAID: MANUAL] = abs(sum(case when active = 1 and r.amount is not null and s.matterid is null then s.settlementpercent else 0 end))/isnull(nullif(abs(sum(case when active = 1 and r.amount is not null and s.matterid is null then 1 else 0 end)),0),1)
	,[Cancelled: Client] = abs(sum(case when active = 1 and MatterStatusCodeId = 42 then s.settlementpercent else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 42 then 1 else 0 end)),0),1)
	,[Rejected: Accounting] = abs(sum(case when active = 1 and MatterStatusCodeId = 41 then s.settlementpercent else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 41 then 1 else 0 end)),0),1)
	,[Rejected: Client] = abs(sum(case when active = 1 and MatterStatusCodeId = 25 then s.settlementpercent else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 25 then 1 else 0 end)),0),1)
	,[Rejected: Manager] = abs(sum(case when active = 1 and (MatterStatusCodeId = 33 or (s.matterid is null and so.rejected is not null) )then s.settlementpercent else 0 end))/isnull(nullif(abs(sum(case when active = 1 and (MatterStatusCodeId = 33 or (s.matterid is null and so.rejected is not null) )then 1 else 0 end)),0),1)
	,[Expired] = abs(sum(case when active = 1 and (MatterStatusCodeId = 43 or (se.settlementid is not null and s.matterid is null )) then s.settlementpercent else 0 end))/isnull(nullif( abs(sum(case when active = 1 and (MatterStatusCodeId = 43 or (se.settlementid is not null and s.matterid is null )) then 1 else 0 end)),0),1)
	,[Other] = abs(sum(case when active = 1 and MatterStatusCodeId = 13 then s.settlementpercent else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 13 then 1 else 0 end)),0),1)
	from tblsettlements s with(nolock) 
	left join tblregister r with(nolock) on s.creditoraccountid = r.accountid and r.entrytypeid = 18 and r.void is null and r.bounce is null 
	left join tblmatter m with(nolock) on s.matterid = m.matterid
	left join tblmattersubstatus sub on m.mattersubstatusid = sub.mattersubstatusid 
	left join (select settlementid from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 5) as rd on rd.settlementid = s.settlementid
	left join (select settlementid from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 9) as se on se.settlementid = s.settlementid
	left join tblSettlements_Overs so with(nolock) on so.settlementid = s.settlementid
	inner join tblclient c with(nolock) on s.clientid = c.clientid
	where year(s.created) = @year and month(s.created) = @month and status='a' 
	group by month(s.created),datename(month,s.created)
	order by  month(s.created),datename(month,s.created)

	insert into @tblr
	select 5,month(getdate()),'Avg Sett Fee'
	,[Offers Made]=abs(sum(case when active = 1 then s.settlementfee else 0 end))/isnull(nullif(abs(sum(case when active = 1 then 1 else 0 end)),0),1)
	,[Waiting On SIF]=abs(sum(case when active = 1 and s.matterid is null and rd.settlementid is not null and (datediff(day,s.settlementduedate,getdate())*-1) >= 0 then s.settlementfee else 0 end))/isnull(nullif(abs(sum(case when active = 1 and s.matterid is null and rd.settlementid is not null and (datediff(day,s.settlementduedate,getdate())*-1) >= 0 then 1 else 0 end)),0),1)
	,[Waiting on Mgr] = abs(sum(case when active = 1 and MatterStatusCodeId = 27 then s.settlementfee else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 27 then 1 else 0 end)),0),1)
	,[Waiting On Client] =abs(sum(case when active = 1 and MatterStatusCodeId = 23 then s.settlementfee else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 23 then 1 else 0 end)),0),1)
	,[Waiting on Accounting] = abs(sum(case when active = 1 and MatterStatusCodeId in(36,38) then s.settlementfee else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId in(36,38) then 1 else 0 end)),0),1)
	,[Waiting in Check By Phone] = abs(sum(case when active = 1 and MatterStatusCodeId = 39 then s.settlementfee else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 39 then 1 else 0 end)),0),1)
	,[Waiting in Process By Email] = abs(sum(case when active = 1 and MatterStatusCodeId = 40 then s.settlementfee else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 40 then 1 else 0 end)),0),1)
	,[Waiting to Print] = abs(sum(case when active = 1 and MatterStatusCodeId = 35 then s.SettlementFeeAmtBeingPaid else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 35 then 1 else 0 end)),0),1)
	,[PAID: Matter] = abs(sum(case when sub.mattersubstatus is not null and active = 1 and MatterStatusCodeId = 37 and isnull(ispaymentarrangement,0)=0 then s.settlementfee else 0 end))/isnull(nullif(abs(sum(case when sub.mattersubstatus is not null and active = 1 and MatterStatusCodeId = 37 and isnull(ispaymentarrangement,0)=0 then 1 else 0 end)),0),1)
	,[PAID: MANUAL] = abs(sum(case when active = 1 and r.amount is not null and s.matterid is null then s.settlementfee else 0 end))/isnull(nullif(abs(sum(case when active = 1 and r.amount is not null and s.matterid is null then 1 else 0 end)),0),1)
	,[Cancelled: Client] = abs(sum(case when active = 1 and MatterStatusCodeId = 42 then s.settlementfee else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 42 then 1 else 0 end)),0),1)
	,[Rejected: Accounting] = abs(sum(case when active = 1 and MatterStatusCodeId = 41 then s.settlementfee else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 41 then 1 else 0 end)),0),1)
	,[Rejected: Client] = abs(sum(case when active = 1 and MatterStatusCodeId = 25 then s.settlementfee else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 25 then 1 else 0 end)),0),1)
	,[Rejected: Manager] = abs(sum(case when active = 1 and (MatterStatusCodeId = 33 or (s.matterid is null and so.rejected is not null) )then s.settlementfee else 0 end))/isnull(nullif(abs(sum(case when active = 1 and (MatterStatusCodeId = 33 or (s.matterid is null and so.rejected is not null) )then 1 else 0 end)),0),1)
	,[Expired] = abs(sum(case when active = 1 and (MatterStatusCodeId = 43 or (se.settlementid is not null and s.matterid is null )) then s.settlementfee else 0 end))/isnull(nullif( abs(sum(case when active = 1 and (MatterStatusCodeId = 43 or (se.settlementid is not null and s.matterid is null )) then 1 else 0 end)),0),1)
	,[Other] = abs(sum(case when active = 1 and MatterStatusCodeId = 13 then s.settlementfee else 0 end))/isnull(nullif(abs(sum(case when active = 1 and MatterStatusCodeId = 13 then 1 else 0 end)),0),1)
	from tblsettlements s with(nolock) 
	left join tblregister r with(nolock) on s.creditoraccountid = r.accountid and r.entrytypeid = 18 and r.void is null and r.bounce is null 
	left join tblmatter m with(nolock) on s.matterid = m.matterid
	left join tblmattersubstatus sub on m.mattersubstatusid = sub.mattersubstatusid 
	left join (select settlementid from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 5) as rd on rd.settlementid = s.settlementid
	left join (select settlementid from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 9) as se on se.settlementid = s.settlementid
	left join tblSettlements_Overs so with(nolock) on so.settlementid = s.settlementid
	inner join tblclient c with(nolock) on s.clientid = c.clientid
	where year(s.created) = @year and month(s.created) = @month and status='a' 
	group by month(s.created),datename(month,s.created)
	order by  month(s.created),datename(month,s.created)

	select 
	--[rOrder],[MonthNum],
	[MonthDescr]
	,[OffersMade]
	,[Waiting On SIF]
	,[Waiting on Mgr]
	,[Waiting On Client]
	,[Waiting on Accounting]
	,[Cancelled: Client]
	,[Rejected: Accounting]
	,[Rejected: Client]
	,[Rejected: Manager]
	,[Expired]
	,[Other] 
	,[Waiting in Check By Phone]
	,[Waiting in Process By Email]
	,[Waiting to Print]
	,[PAID: Matter]
	,[PAID: MANUAL]
	from @tblr 
	order by rOrder,MonthNum desc


END

GO


GRANT EXEC ON stp_settlementimport_reports_getTaskAnalytics TO PUBLIC

GO


