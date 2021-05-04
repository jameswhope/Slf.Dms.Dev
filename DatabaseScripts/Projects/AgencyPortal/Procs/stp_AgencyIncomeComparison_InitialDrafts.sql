 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_AgencyIncomeComparison_InitialDrafts')
	BEGIN
		DROP  Procedure  stp_AgencyIncomeComparison_InitialDrafts
	END

GO

CREATE Procedure [dbo].[stp_AgencyIncomeComparison_InitialDrafts]
(
	@UserID int ,
	@startday varchar(3),
	@endday varchar(3),
	@companyid int = -1
)
as
BEGIN
	declare @CommVSChargeBack table(YearNum int,MonthNum int,TimeFrame varchar(30), CommissionCount int, CommissionAmount money, ChargeBackCount int, ChargeBackAmount money)
	declare @vtblCal table(YearNum int, MonthNum int, DayNum int, timeFrame varchar(100))
	declare @tblCompare table(YearNum int, MonthNum int, timeFrame varchar(100),[Gross Fee Payments] money,[Chargeback] money,[Net Fee Payments] money)
	declare @timeDesc varchar(500)
	
	set @timeDesc = cast(@startday as varchar)+ '-' + cast(@endday as varchar)	

	-- fill calendar 
	--1 year from today
	with    mycte as
	(
	select dateadd(yy,-1,getdate()) DateValue
	union all
	select DateValue + 1 from mycte where DateValue + 1 < getdate()
	)
	insert into @vtblCal
	select  datepart(yy, DateValue) [yearnum],datepart(mm, DateValue) [monthNum],datepart(dd, DateValue) [daynum],
	 left(datename(mm,cast(datepart(mm, DateValue) as varchar) + '/1/' + cast(datepart(yy, DateValue)  as varchar)),3) + ' ' + cast(datepart(yy, DateValue)  as varchar) [timeframe]
	from mycte
	OPTION  (MAXRECURSION 0)
	
	insert into @tblCompare 
	select Yearnum, MonthNum, timeFrame,null,null,null
	from @vtblCal
	group by Yearnum, MonthNum, timeFrame
	order by Yearnum, MonthNum, timeFrame

	--get all registerpaymentids that are initial drafts
	select distinct dp.registerpaymentid 
	into #tempRegPayIDs
	from tblregisterpaymentdeposit dp 
	join vw_initialdrafts df on df.registerid = dp.depositregisterid
	join tblclient c on c.clientid = df.clientid 
	join tbluserclientaccess uc on uc.userid = @UserID and c.created between uc.clientcreatedfrom and uc.clientcreatedto
	join tblusercompanyaccess uca on uca.userid = uc.userid and (@companyid = -1 or uca.companyid = @companyid)
	join tbluseragencyaccess ua on ua.userid = uc.userid and ua.agencyid = c.agencyid

	--Fill Period
	--case for END checks for END then gets the last day of month
	Insert into  @CommVSChargeBack( CommissionCount, CommissionAmount, YearNum, MonthNum, timeframe)
	select 
		count(cp.commpayid) as Qty
		, sum(cp.amount) as Amount
		,year(cbt.batchdate) as [YearNum]
		,month(cbt.batchdate) as [MonthNum]
		,cast(@startday as varchar)+ '-' + cast(case when @endday = 'END' then DAY(DATEADD (m, 1, DATEADD (d, 1 - DAY(cbt.batchdate), cbt.batchdate)) - 1) else @endday end  as varchar)
	from tblcommpay cp
	inner join tblcommbatch cbt on cbt.commbatchid = cp.commbatchid 
	inner join #tempRegPayIDs dpi on dpi.registerpaymentid = cp.registerpaymentid
	inner join tblcommstruct cs on cs.commstructid = cp.commstructid
	inner join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID
	inner join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@companyid = -1 or uca.companyid = @companyid)
	where 
	day(cbt.batchdate) >= @startday and 
	day(cbt.batchdate) <=
	case when @endday = 'END' then DAY(DATEADD (m, 1, DATEADD (d, 1 - DAY(cbt.batchdate), cbt.batchdate)) - 1) else @endday end  and 
	cbt.batchdate >= dateadd(yy,-1,getdate())
	group by  year(cbt.batchdate), month(cbt.batchdate), case when @endday = 'END' then DAY(DATEADD (m, 1, DATEADD (d, 1 - DAY(cbt.batchdate), cbt.batchdate)) - 1) else @endday end  


	select  
	year(cbt.batchdate) as [YearNum]
	,month(cbt.batchdate) as [MonthNum]
	,cast(@startday as varchar)+ '-' + cast(case when @endday = 'END' then DAY(DATEADD (m, 1, DATEADD (d, 1 - DAY(cbt.batchdate), cbt.batchdate)) - 1) else @endday end  as varchar) [timeframe]
	,count(cb.commchargebackid) as Qty
	, sum(cb.amount) as Amount
	into #tblTemp
	from tblcommchargeback cb
	inner join tblcommbatch cbt on cbt.commbatchid = cb.commbatchid 
	inner join #tempRegPayIDs dpi on dpi.registerpaymentid = cb.registerpaymentid
	inner join tblcommstruct cs on cs.commstructid = cb.commstructid
	inner join tblusercommrecaccess ucra on ucra.commrecid = cs.commrecid and ucra.userid = @UserID	
	inner join tblusercompanyaccess uca on uca.companyid = cs.companyid and uca.userid = ucra.userid and (@companyid = -1 or uca.companyid = @companyid)
	where 
	day(cbt.batchdate) >= @startday and 
	day(cbt.batchdate) <=
	case when @endday = 'END' then DAY(DATEADD (m, 1, DATEADD (d, 1 - DAY(cbt.batchdate), cbt.batchdate)) - 1) else @endday end  
	and cbt.batchdate > dateadd(yy,-1,getdate())
	group by  year(cbt.batchdate), month(cbt.batchdate), cast(case when @endday = 'END' then DAY(DATEADD (m, 1, DATEADD (d, 1 - DAY(cbt.batchdate), cbt.batchdate)) - 1) else @endday end  as varchar)



	Update @CommVSChargeBack Set
	ChargeBackCount = t.Qty,
	ChargeBackAmount = t.Amount
	From @CommVSChargeBack c
	join #tblTemp t on t.monthnum = c.monthnum and t.yearnum = c.yearnum and t.timeframe = c.timeframe


	Insert into  @CommVSChargeBack( ChargeBackCount, ChargeBackAmount, timeframe,MonthNum, YearNum)
	Select  t.qty, t.amount, t.timeframe,t.monthnum,t.yearnum 
	from #tblTemp t
	where t.timeframe not in (select timeframe from @CommVSChargeBack)


	update @tblCompare	set 
		[Gross Fee Payments] = t1.[Gross Fee Payments],
		[Chargeback] = t1.[Chargeback],
		[Net Fee Payments] = t1.[Net Fee Payments]
	FROM 
	(
	select 
	 left(datename(mm,cast(cb.monthnum as varchar) + '/1/' + cast(cb.yearnum as varchar)),3) + ' ' + cast(cb.yearnum as varchar) [timeframe]
	, isnull(sum(CommissionAmount),0)[Gross Fee Payments]
	, isnull(sum(ChargeBackAmount) ,0)[Chargeback]
	, isnull(sum(CommissionAmount),0) - isnull(sum(ChargeBackAmount) ,0)[Net Fee Payments]
	from @CommVSChargeBack cb
		inner join @tblCompare cp ON cp.YearNum = cb.YearNum and cp.monthnum = cb.monthnum
	group by cb.yearnum,cb.monthnum,cb.timeframe
	) t1
	inner join @tblCompare cp ON cp.[timeframe] = t1.[timeframe] 
	;
	
	select 
		[timeframe]
		,isnull([Gross Fee Payments],0)[Gross Fee Payments]
		,isnull([Chargeback],0)[Chargeback]
		,isnull([Net Fee Payments],0)[Net Fee Payments]
	from @tblCompare
	order by yearnum, monthnum
	drop table #tblTemp
	drop table #tempRegPayIDs
END