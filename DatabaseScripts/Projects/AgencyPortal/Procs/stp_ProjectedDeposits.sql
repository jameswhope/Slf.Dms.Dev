
alter procedure stp_ProjectedDeposits
as
begin

declare @LastProjection varchar(10), @StartDate datetime, @EndDate datetime--, @days int

select @LastProjection = convert(varchar(10), max(ProjectedOn), 101) from tblPotentialDeposits
select @StartDate = cast(convert(varchar(10), dateadd(day,-4,getdate()), 101) as datetime)
select @EndDate = cast(convert(varchar(10), dateadd(day,5,getdate()), 101) as datetime)


select agency, company, date, amount
into #deposits
from (
	-- actual deposits
	select a.name [agency], comp.name [company], cast(convert(varchar(10),r.transactiondate,101) as datetime) [date], sum(r.amount) [amount]
	from tblregister r
	join tblclient c on c.clientid = r.clientid
	join tblagency a on a.agencyid = c.agencyid
	join tblcompany comp on comp.companyid = c.companyid
	where r.entrytypeid = 3 and
		r.transactiondate >= @startdate and
		(
			r.hold is null or r.hold <= getdate() or r.[clear] <= getdate()
		)
	group by a.name, comp.name, cast(convert(varchar(10),r.transactiondate,101) as datetime)

	union all

	-- latest projections
	select a.name [agency], c.name [company], p.fordate [date], sum(amount) [amount]
	from tblPotentialDeposits p
	join tblagency a on a.agencyid = p.agencyid
	join tblcompany c on c.companyid = p.companyid
	where convert(varchar(10), ProjectedOn, 101) = @LastProjection
	group by a.name, c.name, p.fordate
) d

 
select distinct date
from #deposits
order by date

select distinct agency
from #deposits
order by agency

select distinct company
from #deposits
order by company

select agency, date, sum(amount) [amount]
from #deposits
group by agency, date
order by agency, date

select agency, company, date, sum(amount) [amount]
from #deposits
group by agency, company, date
order by agency, company, date

-- projections
select c.name [company], a.name [agency], p.fordate, projectedon, amount
from tblPotentialDeposits p
join tblcompany c on c.companyid = p.companyid
join tblagency a on a.agencyid = p.agencyid
where p.fordate between @StartDate and @EndDate
order by c.name, a.name, projectedon desc, fordate


drop table #deposits

end
go