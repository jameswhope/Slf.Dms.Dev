IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_settlementpipeline')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_settlementpipeline
	END

GO

CREATE Procedure stp_settlementimport_reports_settlementpipeline
	(
		@year int
	)
AS
BEGIN
	declare @tblData table(YearNumber int,MonthNumber int,[MonthName] varchar(50),Offers int
	,[Submitted: With Funds] varchar(50),[Submitted: Future Deposit] varchar(50),[Submitted: Shortage] varchar(50)
	,[Waiting: SIF] varchar(50),[Waiting: MGR] varchar(50),[Waiting: Client] varchar(50),[Waiting: Accounting] varchar(50),[Waiting: Deposit] varchar(50),[Waiting: LC/SA Approval] varchar(50)
	,[Processing: Chk By Phone] varchar(50),[Processing: Email] varchar(50),[Processing: Print] varchar(50))

	insert into @tblData 
	select 
		[YearNumber] = year(s.created)
		, [MonthNumber]=month(s.created)
		, [MonthName]=datename(month,s.created)
		, [Offers]=count(*)
		, [Submitted: With Funds] = sum(case when availsda >= settlementamount then 1 else 0 end)
		, [Submitted: Future Deposit] = sum(case when availsda + vcnd.nextdepositamount >= settlementamount and availsda < settlementamount then 1 else 0 end)
		, [Submitted: Shortage] = sum(case when availsda < settlementamount and availsda + vcnd.nextdepositamount < settlementamount then 1 else 0 end)
		, [Waiting: SIF] = sum(case when datediff(d,s.settlementduedate,getdate())*-1>= 0 and rd.stepid = 5 then 1 else 0 end)
		, [Waiting: MGR] = sum (case when m.MatterStatusCodeId = 27 or (so.settlementid is not null and so.approved is null and so.rejected is null and s.matterid is null) then 1 else 0 end)
		, [Waiting: Client] = sum(case when m.MatterStatusCodeId = 23 or (s.matterid is null and (isnull(isclientstipulation,0)=1 or isnull(ispaymentarrangement,0)=1) and datediff(d,s.settlementduedate,getdate())*-1>= 0 and settpaid.registerid is null) then 1 else 0 end)
		, [Waiting: Accounting]= sum(case when MatterStatusCodeId in(36,38) and settpaid.registerid is null then 1 else 0 end)
		, [Waiting: Deposit] = sum(case when MatterStatusCodeId in(35,39,40) and settpaid.registerid is null and (availsda < settlementamount and availsda + vcnd.nextdepositamount < settlementamount) then 1 else 0 end)
		, [Waiting: LC/SA Approval] = sum(case when m.MatterStatusCodeId = 13 then 1 else 0 end)
		, [Processing: Chk By Phone] = sum(case when MatterStatusCodeId = 39 and settpaid.registerid is null then 1 else 0 end)
		, [Processing: Email] = sum(case when m.MatterStatusCodeId = 40 and settpaid.registerid is null then 1 else 0 end)
		, [Processing: Print] = sum(case when m.MatterStatusCodeId = 35 and settpaid.registerid is null then 1 else 0 end)
	from tblsettlements s with(nolock)
	left join vwClientNextDepositSchedule vcnd with(nolock)  on vcnd.clientid = s.clientid
	left join (select settlementid,max(settlementstatusid)[stepid] from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 5) as rd on rd.settlementid = s.settlementid
	left join tblsettlements_overs so with(nolock) on so.settlementid = s.settlementid
	left join tblregister settpaid with(nolock) on s.creditoraccountid = settpaid.accountid and settpaid.entrytypeid in(18) and settpaid.void is null and settpaid.bounce is null 
	left join tblmatter m with(nolock) on s.matterid = m.matterid
	where status = 'a' and active = 1
	and s.created between convert(varchar(10),dateadd(d,-day(getdate()-1),dateadd(yy,-1,getdate())),101) and convert(varchar(10),dateadd(d,-day(getdate()),dateadd(m,1,getdate())),101)
	group by year(s.created),month(s.created),datename(month,s.created)


	select 
		[YearNumber]
		,MonthNumber	
		,[MonthName]
		,[Offers]
		,[Submitted: With Funds]=[Submitted: With Funds] + ' (' + cast(cast((cast([Submitted: With Funds] as float)/cast([Offers] as float))*100 as numeric(18,2)) as varchar) + '%)'
		,[Submitted: Future Deposit]=[Submitted: Future Deposit] + ' (' + cast(cast((cast([Submitted: Future Deposit] as float)/cast([Offers] as float))*100 as numeric(18,2)) as varchar) + '%)'
		,[Submitted: Shortage]=[Submitted: Shortage] + ' (' + cast(cast((cast([Submitted: Shortage] as float)/cast([Offers] as float))*100 as numeric(18,2)) as varchar) + '%)'
		,[Waiting: SIF]
		,[Waiting: MGR]
		,[Waiting: Client] 
		,[Waiting: Accounting] 
		,[Waiting: Deposit] 
		,[Waiting: LC/SA Approval] 
		,[Processing: Chk By Phone] 
		,[Processing: Email] 
		,[Processing: Print] 
	from 
		@tblData 
	order by 
		yearnumber desc, monthnumber desc

END

GO


GRANT EXEC ON stp_settlementimport_reports_settlementpipeline TO PUBLIC

GO


