if exists (select * from sysobjects where name = 'stp_AgencyInitialDraftsCommission')
	drop procedure stp_AgencyInitialDraftsCommission
go

create procedure stp_AgencyInitialDraftsCommission
(
	@startdate datetime = '2006-01-01',
	@enddate datetime = null,
	@dateperiod varchar(1) = 'm',
	@userid int,
	@companyid int = -1
)
AS
BEGIN

	declare @CommVSChargeBack table(Period datetime, CommissionCount int, CommissionAmount money, ChargeBackCount int, ChargeBackAmount money)
	
	select distinct dp.registerpaymentid 
	into #dpt
	from tblregisterpaymentdeposit dp 
	inner join vw_initialdrafts df on df.registerid = dp.depositregisterid
	inner join tblclient c on c.clientid = df.clientid 
	inner join tbluserclientaccess uc on uc.userid = @UserID and c.created between uc.clientcreatedfrom and uc.clientcreatedto
	inner join tblusercompanyaccess uca on uca.userid = uc.userid and (@CompanyID = -1 or uca.companyid = @CompanyID)
	inner join tbluseragencyaccess ua on ua.userid = uc.userid and ua.agencyid = c.agencyid


	--Fill Period
	Insert into  @CommVSChargeBack( CommissionCount, CommissionAmount, Period)
	select count(cp.commpayid) as Qty, 
		   sum(cp.amount) as Amount,  
		   dbo.udf_DatePartStart(@dateperiod,cbt.batchdate) as [period]
	from tblcommpay cp
	inner join tblcommbatch cbt on cbt.commbatchid = cp.commbatchid 
	inner join tblcommstruct cs on cs.commstructid = cp.commstructid
	inner join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID
	inner join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@CompanyID = -1 or uca.companyid = @CompanyID)
	inner join #dpt dpi on dpi.registerpaymentid = cp.registerpaymentid	
	where cbt.batchdate >= @startDate and cbt.batchdate < isnull(@enddate, getdate())
	group by  dbo.udf_DatePartStart(@dateperiod, cbt.batchdate)

	select count(cb.commchargebackid) as Qty, sum(cb.amount) as Amount,  dbo.udf_DatePartStart(@dateperiod,cbt.batchdate) as [period] 
	into #t
	from tblcommchargeback cb
	inner join tblcommbatch cbt on cbt.commbatchid = cb.commbatchid 
	inner join tblcommstruct cs on cs.commstructid = cb.commstructid
	inner join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID
	inner join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@CompanyID = -1 or uca.companyid = @CompanyID)
	inner join #dpt dpi on dpi.registerpaymentid = cb.registerpaymentid	
	where cbt.batchdate >= @startDate and cbt.batchdate < isnull(@enddate, getdate())
	group by  dbo.udf_DatePartStart(@dateperiod, cbt.batchdate)

	Update @CommVSChargeBack Set
	ChargeBackCount = t.Qty,
	ChargeBackAmount = t.Amount
	From @CommVSChargeBack c
	join #t t on t.period = c.period

	Insert into  @CommVSChargeBack( ChargeBackCount, ChargeBackAmount, Period)
	Select  t.qty, t.amount, t.period 
	from #t t
	where t.period not in (select period from @CommVSChargeBack)


	declare @income varchar(1000), @chargeback varchar(1000), @net varchar(1000)

	select @income = coalesce(@income + ', ', '') + cast(isnull(CommissionAmount,0) as varchar(20)) + ' [' + dbo.udf_DatePartName(@DatePeriod, Period) + ']'
	from @CommVSChargeBack
	order by Period

	select @chargeback = coalesce(@chargeback + ', ', '') + cast(isnull(ChargeBackAmount,0) as varchar(20)) 
	from @CommVSChargeBack
	order by Period

	select @net = coalesce(@net + ', ', '') + cast((isnull(CommissionAmount,0) - isnull(ChargeBackAmount,0)) as varchar(20)) 
	from @CommVSChargeBack
	order by Period
	
	if @income is null begin
		set @income = '0 [' + dbo.udf_DatePartName(@DatePeriod, dateadd(day,-1,@enddate)) + ']'
	end
	if @chargeback is null begin
		set @chargeback = '0'
	end
	if @net is null begin
		set @net = '0'
	end

	exec('
		select ''Gross Fee Payments'' [Label], ' + @income + '
		union all
		select ''Chargeback'', ' + @chargeback + '
		union all 
		select ''Net Fee Payments'', ' + @net
		)


	drop table #dpt
	drop table #t

END 


