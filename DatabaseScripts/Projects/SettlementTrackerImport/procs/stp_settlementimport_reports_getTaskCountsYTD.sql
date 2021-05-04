IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getTaskCountsYTD')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getTaskCountsYTD
	END

GO

CREATE Procedure stp_settlementimport_reports_getTaskCountsYTD
AS
BEGIN
	declare @DateStart datetime
	declare @DateEnd datetime

	set @DateStart = '1/1/' + cast(year(getdate()) as varchar) 
	set @DateEnd = dateadd(d,-day(getdate()), dateadd(m,1,getdate()))

	IF (@DateStart IS NOT NULL) 
		BEGIN 
			SET @DateStart = CAST((CAST (DATEPART (yyyy,@DateStart) AS NVARCHAR(4)) +'/'+ CAST (DATEPART (mm,@DateStart) AS NVARCHAR(2)) +'/'+ CAST (DATEPART (dd,@DateStart) AS NVARCHAR(2)) +' '+ '00:00:00.000') AS DATETIME) 
		END 
	IF (@DateEnd IS NOT NULL) 
		BEGIN 
			SET @DateEnd = CAST ((CAST (DATEPART (yyyy,@DateEnd) AS NVARCHAR(4)) +'/'+ CAST (DATEPART (mm,@DateEnd) AS NVARCHAR(2)) +'/'+ CAST (DATEPART (dd,@DateEnd) AS NVARCHAR(2)) +' '+ '23:59:59.997' ) AS DATETIME) 
		END 

	select 
		[MonthNum]=month(s.created)
		,[MonthDesc]=datename(month,s.created)
		,[Offers Made]=count(*)
		,[Waiting On SIF]=sum(case when s.matterid is null 
							and rd.settlementid is null 
							and (datediff(day,s.settlementduedate,getdate())*-1) >= 0 then 1 else 0 end)
		,[Waiting on Mgr] = sum(case when m.MatterStatusCodeId = 27 then 1 else 0 end)
		,[Waiting On Client] = sum(case when m.MatterStatusCodeId = 23 then 1 else 0 end)
		,[Waiting on Accounting] = sum(case when m.MatterStatusCodeId = 38 then 1 else 0 end)
		,[Cancelled: Client] = sum(case when m.MatterStatusCodeId = 42 then 1 else 0 end)
		,[Rejected: Accounting] = sum(case when m.MatterStatusCodeId = 41 then 1 else 0 end)
		,[Rejected: Client] = sum(case when m.MatterStatusCodeId = 25 then 1 else 0 end)
		,[Rejected: Manager] = sum(case when m.MatterStatusCodeId = 33 or (s.matterid is null and so.rejected is not null) then 1 else 0 end)
		,[Expired] = sum(case when m.MatterStatusCodeId = 43 or (rd.settlementid is not null and r.registerid is null) then 1 else 0 end)
		,[Other]  = sum(case when m.MatterStatusCodeId = 13 then 1 else 0 end)
		,[Waiting in Check By Phone] = sum(case when m.MatterStatusCodeId = 39 then 1 else 0 end)
		,[Waiting in Process By Email] = sum(case when m.MatterStatusCodeId = 40 then 1 else 0 end)
		,[Waiting to Print] = sum(case when m.MatterStatusCodeId = 35 then 1 else 0 end)
		,[PAID: Matter] = sum(case when m.MatterStatusCodeId = 37 then 1 else 0 end)
		,[PAID: MANUAL] = sum(case when s.matterid is null and r.registerid is not null then 1 else 0 end) 
		,[Collected in Month] = abs(sum(case when active = 1 and rf.registerid is not null and year(rf.transactiondate) = year(s.created) and month(rf.transactiondate) = month(s.created) then rf.amount else 0 end))
		,[Collected Total] = abs(sum(case when active = 1 and rf.registerid is not null then rf.amount else 0 end))
		from tblsettlements s with(nolock)
		left join tblmatter m with(nolock) on s.matterid = m.matterid
		left join tblmattersubstatus sub on m.mattersubstatusid = sub.mattersubstatusid 
		left join tblregister r with(nolock) on s.creditoraccountid = r.accountid and r.entrytypeid = 18 and r.void is null and r.bounce is null 
		left join tblregister rf with(nolock) on s.creditoraccountid = rf.accountid and rf.entrytypeid = 4 and rf.void is null and rf.bounce is null 
		left join tblmatterstatuscode msc on msc.MatterStatusCodeId = m.MatterStatusCodeId
		left join (select settlementid from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 9 ) as rd on rd.settlementid = s.settlementid
		left join (select settlementid from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 5 ) as att on att.settlementid = s.settlementid
		left join tblSettlements_Overs so with(nolock) on so.settlementid = s.settlementid
		where active = 1 and status = 'a' and s.created between @DateStart and @DateEnd 
		group by month(s.created),datename(month,s.created)
		order by month(s.created) desc
		option (fast 100)
END

GO


GRANT EXEC ON stp_settlementimport_reports_getTaskCountsYTD TO PUBLIC

GO


