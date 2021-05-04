IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ReportCommissionVsChargebackDailyComparison')
	BEGIN
		DROP  Procedure  stp_ReportCommissionVsChargebackDailyComparison
	END

GO

CREATE procedure [dbo].[stp_ReportCommissionVsChargebackDailyComparison]
(
	@daynum int = NULL
)
as 
BEGIN

	if @daynum is null
		set @daynum = day(getdate())


	declare @CommVSChargeBack table(YearNum int,MonthNum int,DayNum int, CommissionCount int, CommissionAmount money, ChargeBackCount int, ChargeBackAmount money)
	declare @vtblTemp table (YearNum int,MonthNum int,DayNum int,Qty int,Amount money)
	declare @vtblCal table(YearNum int, MonthNum int, DayNum int)
	-- fill calendar
		
		with    mycte as
		(
		select cast('1/1/' + cast(year(dateadd(yy,0,getdate())) as varchar) as datetime) DateValue
		union all
		select DateValue + 1
		from    mycte    
		where   DateValue + 1 < cast('12/31/' + cast(year(dateadd(yy,0,getdate())) as varchar) as datetime)
		)
		insert into @vtblCal
		select  datepart(yy, DateValue) [yearnum],datepart(mm, DateValue) [monthNum],datepart(dd, DateValue) [daynum]
		from mycte
		OPTION  (MAXRECURSION 0)

	--Fill Period
	Insert into  @CommVSChargeBack( CommissionCount, CommissionAmount, DayNum,MonthNum, YearNum)
	select count(cp.commpayid) as Qty, 
		   sum(cp.amount) as Amount,  
		   day(rp.paymentdate) as [DayNum],
		   month(rp.paymentdate) as [MonthNum],
		   year(rp.paymentdate) as [YearNum]
	from tblcommpay cp
	inner join tblregisterpayment rp on rp.registerpaymentid = cp.registerpaymentid
	where day(rp.paymentdate) = @daynum 
	group by year(rp.paymentdate),month(rp.paymentdate), day(rp.paymentdate) 

	insert into @vtblTemp
	select year(cb.chargebackdate) as [YearNum],month(cb.chargebackdate) as [MonthNum],day(cb.chargebackdate) as [DayNum] , count(cb.commchargebackid) as Qty, sum(cb.amount) as Amount
	from tblcommchargeback cb
	where day(cb.chargebackdate) = @daynum
	group by  year(cb.chargebackdate),month(cb.chargebackdate),  day(cb.chargebackdate) 

	Update @CommVSChargeBack Set
	ChargeBackCount = t.Qty,
	ChargeBackAmount = t.Amount
	From @CommVSChargeBack c
	join @vtblTemp t on t.daynum = c.daynum and t.monthnum = c.monthnum

	select 
	vc.yearnum
	, vc.monthnum
	, vc.daynum
	, isnull(vt.commissioncount,0) [IncomeCount]
	, isnull(vt.commissionamount,0) [IncomeAmount]
	, isnull(vt.ChargeBackCount,0) [ChargeBackCount]
	, isnull(vt.ChargeBackAmount,0) [ChargeBackAmount]
	
	from @vtblCal as vc 
	left outer join @CommVSChargeBack as vt on vc.yearnum = vt.yearnum and vc.monthnum = vt.monthnum
	where vc.daynum = @daynum
	order by vc.yearNum, vc.monthnum
END



GRANT EXEC ON stp_ReportCommissionVsChargebackDailyComparison TO PUBLIC



