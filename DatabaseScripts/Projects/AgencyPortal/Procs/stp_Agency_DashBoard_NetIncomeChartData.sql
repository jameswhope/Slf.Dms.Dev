IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Agency_DashBoard_NetIncomeChartData')
	BEGIN
		DROP  Procedure  stp_Agency_DashBoard_NetIncomeChartData
	END

GO

CREATE procedure [stp_Agency_DashBoard_NetIncomeChartData]
(
	@UserID int,
	@CompanyID int = -1 
)

as
BEGIN
	declare @startdate datetime 
	set @startdate = dateadd(d,-15,getdate())

	declare @CommVSChargeBack table(Period datetime, CommissionCount int, CommissionAmount money, ChargeBackCount int, ChargeBackAmount money)
	declare @vtblCal table(TransActionDate datetime);
		
	-- fill calendar
	with    mycte as
	(
	select cast('1/1/' + cast(year(getdate()) as varchar) as datetime) DateValue
	union all
	select DateValue + 1
	from    mycte    
	where   DateValue + 1 <= getdate()
	)
	insert into @vtblCal
	select  top 5 DateValue
	from    mycte
	where CONVERT(BIT, CASE WHEN datepart(dw, DateValue) IN (1,7) THEN 0 ELSE 1 END) = 1 and datevalue < getdate() order by datevalue desc
	OPTION  (MAXRECURSION 0)

	--Fill Period
	Insert into  @CommVSChargeBack( CommissionCount, CommissionAmount, Period)
	select count(cp.commpayid) as Qty, 
		   sum(cp.amount) as Amount,  
		   convert(varchar(10),cbt.batchdate,101) as [period]
	from tblcommpay cp
	inner join tblcommbatch cbt on cbt.commbatchid = cp.commbatchid and cbt.batchdate >= @startDate  
	inner join tblcommstruct cs on cs.commstructid = cp.commstructid
	inner join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID	
	inner join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@CompanyID = -1 or uca.companyid = @CompanyID)
	inner join tblregisterpayment rp on rp.registerpaymentid = cp.registerpaymentid
	inner join tblregister r on r.registerid = rp.feeregisterid
	inner join tblclient c on c.clientid = r.clientid 	
	inner join tbluserclientaccess uc on uc.userid = uca.userid and c.created between uc.clientcreatedfrom and uc.clientcreatedto	
	inner join tbluseragencyaccess ua on ua.userid = uc.userid and ua.agencyid = c.agencyid
	group by  convert(varchar(10),cbt.batchdate,101) 

	select count(cb.commchargebackid) as Qty, sum(cb.amount) as Amount, convert(varchar(10),cbt.batchdate,101) as [period] 
	into #t
	from tblcommchargeback cb
	inner join tblcommbatch cbt on cbt.commbatchid = cb.commbatchid and cbt.batchdate >= @startDate 
	inner join tblcommstruct cs on cs.commstructid = cb.commstructid
	inner join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID	
	inner join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@CompanyID = -1 or uca.companyid = @CompanyID)
	inner join tblregisterpayment rp on rp.registerpaymentid = cb.registerpaymentid
	inner join tblregister r on r.registerid = rp.feeregisterid
	inner join tblclient c on c.clientid = r.clientid 
	inner join tbluserclientaccess uc on uc.userid = uca.userid and c.created between uc.clientcreatedfrom and uc.clientcreatedto	
	inner join tbluseragencyaccess ua on ua.userid = uc.userid and ua.agencyid = c.agencyid
	group by  convert(varchar(10),cbt.batchdate,101)

	Update @CommVSChargeBack Set
	ChargeBackCount = t.Qty,
	ChargeBackAmount = t.Amount
	From @CommVSChargeBack c
	join #t t on t.period = c.period

	Insert into  @CommVSChargeBack( ChargeBackCount, ChargeBackAmount, Period)
	Select  t.qty, t.amount, t.period 
	from #t t
	where t.period not in (select period from @CommVSChargeBack)

	declare @income varchar(1000), @chargeback varchar(1000), @net varchar(1000), @balance varchar(1000)

	select @net = coalesce(@net + ', ', '') + cast((isnull(CommissionAmount,0) - isnull(ChargeBackAmount,0)) as varchar(20)) + ' [' +  cast(month(vc.transactiondate) as varchar) + '/' + cast(day(vc.transactiondate) as varchar) + ']'
	from @vtblCal as vc 
	left outer join @CommVSChargeBack as ccb on convert(varchar(10),ccb.period,101) = convert(varchar(10),vc.transactiondate,101)
	order by vc.transactiondate

	exec('
		select ''Net Fee Payments'', ' + @net
		)

	drop table #t
END