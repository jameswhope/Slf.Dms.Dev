
create procedure stp_ProjectedPayments
as
begin

declare @LastProjection varchar(10), @StartDate datetime, @EndDate datetime

select @LastProjection = convert(varchar(10), max(ProjectedOn), 101) from tblPotentialCommPay
select @StartDate = cast(convert(varchar(10), dateadd(day,-4,getdate()), 101) as datetime)
select @EndDate = cast(convert(varchar(10), dateadd(day,5,getdate()), 101) as datetime)


select commrec, company, date, amount
into #payments
from (
	-- actual payments
	SELECT
		cr.display [commrec], 
		comp.name [company],
		convert(varchar(10),rp.paymentdate,101) [date],
		sum(cp.amount) [amount]
	FROM
		tblCommPay as cp
		join tblRegisterPayment as rp on rp.RegisterPaymentID = cp.RegisterPaymentID
		join tblRegister as r on r.RegisterID = rp.FeeRegisterID
		join tblClient as c on c.ClientID = r.ClientID
		join tblcompany comp on comp.companyid = c.companyid
		join tblCommStruct as cs on cs.CommStructID = cp.CommStructID 
		join tblcommrec cr on cr.commrecid = cs.commrecid
	WHERE
		rp.paymentdate between @startdate and @enddate
	group by
		cr.display, comp.name, convert(varchar(10),rp.paymentdate,101)

	union all

	-- latest projected payments
	select cr.display, c.name, convert(varchar(10),fordate,101), sum(amount)
	from tblpotentialcommpay p
	join tblcompany c on c.companyid = p.companyid
	join tblcommrec cr on cr.commrecid = p.commrecid
	where convert(varchar(10), ProjectedOn, 101) = @LastProjection
	group by cr.display, c.name, p.fordate
) d


select distinct date
from #payments
order by date

select distinct commrec
from #payments
order by commrec

select distinct company
from #payments
order by company

select commrec, date, sum(amount) [amount]
from #payments
group by commrec, date
order by commrec, date

select commrec, company, date, sum(amount) [amount]
from #payments
group by commrec, company, date
order by commrec, company, date

-- projections
select c.name [company], cr.display [commrec], p.fordate, projectedon, amount
from tblPotentialCommPay p
join tblcompany c on c.companyid = p.companyid
join tblcommrec cr on cr.commrecid = p.commrecid
where p.fordate <= @enddate
order by c.name, cr.display, projectedon desc, fordate


drop table #payments

end
go 