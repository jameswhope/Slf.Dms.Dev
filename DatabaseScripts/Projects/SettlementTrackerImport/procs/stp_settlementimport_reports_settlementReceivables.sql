IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_settlementReceivables')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_settlementReceivables
	END

GO

CREATE Procedure stp_settlementimport_reports_settlementReceivables
	(
		@year int
	)
AS
BEGIN
	declare @tblData table(YearNumber int,MonthNumber int,[MonthName] varchar(50)
	,[In Month: Earned] money,[In Month: Collected] money,[In Month: Difference] money
	,[Balance: Receivables] money,[Collected: Receivables] money,[Uncollectable] money
	,[New: Receivables] money
	)

	insert into @tblData 
	select 
		[YearNumber] = year(s.created)
		,[MonthNumber]=month(s.created)
		,[MonthName]=datename(month,s.created)
		,[In Month: Earned] = sum(s.settlementfee)
		,[In Month: Collected] = sum(case when month(rp.paymentdate) = month(s.created) then abs(isnull(rp.Amount,0)) else 0 end)
		,[In Month: Difference]= 0
		,[Balance: Receivables] = 0--sum(abs(isnull(rp.Amount,0))) + COALESCE((SELECT SUM(Amount) FROM tblregisterpayment rpbr with(nolock) WHERE isnull(voided,0)=0 and isnull(bounced,0)=0 and month(rpbr.paymentdate) = month(s.created)-1),0)
		,[Collected: Receivables] = sum(case when month(rp.paymentdate) <> month(s.created) then abs(isnull(rp.Amount,0)) else 0 end)
		,[Uncollectable] = sum(abs(isnull(vrp.Amount,0))) + sum(case when c.currentclientstatusid in (17) then abs(isnull(rp.Amount,0)) else 0 end)
		,[New: Receivables]= 0
	from tblsettlements s with(nolock)
	left join vwClientNextDepositSchedule vcnd with(nolock)  on vcnd.clientid = s.clientid
	left join (select settlementid,max(settlementstatusid)[stepid] from tblnegotiationroadmap with(nolock) group by settlementid having max(settlementstatusid) = 5) as rd on rd.settlementid = s.settlementid
	left join tblsettlements_overs so with(nolock) on so.settlementid = s.settlementid
	left join tblregister settfees with(nolock) on s.creditoraccountid = settfees.accountid and settfees.entrytypeid = 4 and settfees.void is null and settfees.bounce is null 
	left join (select feeregisterid, sum(amount)[Amount], max(paymentdate)[paymentdate] from tblregisterpayment where isnull(voided,0)=0 and isnull(bounced,0)=0 group by feeregisterid) rp  on rp.feeregisterid = settfees.registerid 
	left join (select feeregisterid, sum(amount)[Amount], max(paymentdate)[paymentdate] from tblregisterpayment where isnull(voided,0)=1 and isnull(bounced,0)=1 group by feeregisterid) vrp  on vrp.feeregisterid = settfees.registerid 
	left join tblmatter m with(nolock) on s.matterid = m.matterid
	inner join tblclient c with(nolock) on c.clientid = s.clientid
	where status = 'a' and active = 1
	and s.created between convert(varchar(10),dateadd(d,-day(getdate()-1),dateadd(yy,-1,getdate())),101) and convert(varchar(10),dateadd(d,-day(getdate()),dateadd(m,1,getdate())),101)
	group by year(s.created),month(s.created),datename(month,s.created)

	
	update @tblData 
	set [Balance: Receivables] = (select sum(abs(amount) )
	from tblregister settfees with(nolock) inner join tblclient c with(nolock) on c.clientid = settfees.clientid
	where settfees.entrytypeid = 4 and settfees.void is null and settfees.bounce is null and isnull(settfees.isfullypaid,0) = 0 and  not c.currentclientstatusid in (17)
	and settfees.transactiondate < cast(t.monthnumber as varchar) + '/1/' + cast(@year as varchar))
	from @tblData t

	select 
		[YearNumber]
		,MonthNumber	
		,[MonthName]
		,[In Month: Earned] 
		,[In Month: Collected] 
		,[In Month: Difference] = [In Month: Earned] - [In Month: Collected] 
		,[Balance: Receivables] 
		,[Collected: Receivables] 
		,[Uncollectable] 
		,[New: Receivables] = (([In Month: Earned] - [In Month: Collected] ) 
								+ [Balance: Receivables] ) 
								- [Collected: Receivables] 
								- [Uncollectable] 
	from 
		@tblData t
	order by 
		yearnumber desc, monthnumber desc


END

GO


GRANT EXEC ON stp_settlementimport_reports_settlementReceivables TO PUBLIC

GO

