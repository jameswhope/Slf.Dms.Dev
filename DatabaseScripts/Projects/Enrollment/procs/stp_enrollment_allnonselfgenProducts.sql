if exists (select 1 from sysobjects where name = 'stp_enrollment_allnonselfGenProducts')
	drop procedure stp_enrollment_allnonselfGenProducts
go

create procedure stp_enrollment_allnonselfGenProducts
(
	@date datetime
)
as

declare @month int, @year int

set @month = month(@date)
set @year = year(@date)

select v.vendorcode, p.productid,
	sum(case when month(l.created) = @month and year(l.created) = @year then 1 else 0 end) [totalleads],
	max(cast(convert(varchar(10),l.created,101) as datetime))[productlastlead]
into #temp
from tblleadproducts p 
join tblleadvendors v on v.vendorid = p.vendorid 
join tblleadapplicant l on l.productid = p.productid 
where v.categoryid <> 101 
and month(l.created) = @month
and year(l.created) = @year
and l.refund = 0
group by v.vendorcode, p.productid


select c.category, '' [vendorcode], -1 [productid], '' [productcode], 0 [currentcost], 0 [cost], 
	sum(case when month(l.created) = @month and year(l.created) = @year then 1 else 0 end) [noleads], 
	min(l.created) [firstlead],
	max(l.created)[lastlead], 
	max(l.created)[productlastlead], 
	sum(case when month(l.created) = @month and year(l.created) = @year then 1 else 0 end) [totalleads],
	0 [seq],
	0 [newcost], 
	'1/1/1900' [effectivedate],
	sum(l.cost) [spent]
from tblleadvendors v
join tblleadcategories c on c.categoryid = v.categoryid 
join tblleadproducts p on p.vendorid = v.vendorid
left join tblleadapplicant l on l.productid = p.productid 
where v.categoryid <> 101
and month(l.created) = @month
and year(l.created) = @year
and l.refund = 0
group by c.category

union all

select c.category, v.vendorcode, p.productid, p.productcode, p.cost [currentcost], l.cost, 
	sum(case when month(l.created) = @month and year(l.created) = @year then 1 else 0 end) [noleads],
	min(l.created) [firstlead],
	max(l.created) [lastlead],
	t.productlastlead,
	t.totalleads,
	1 [seq],
	case when month(getdate()) = @month and year(getdate()) = @year then isnull(p.newcost,0) else 0 end [newcost],
	case when month(getdate()) = @month and year(getdate()) = @year then isnull(p.effectivedate,'1/1/1900') else '1/1/1900' end [effectivedate],
	sum(l.cost) [spent]
from tblleadproducts p 
join tblleadvendors v on v.vendorid = p.vendorid 
join tblleadcategories c on c.categoryid = v.categoryid 
join tblleadapplicant l on l.productid = p.productid 
join #temp t on t.vendorcode = v.vendorcode and t.productid = p.productid
where v.categoryid <> 101 
and month(l.created) = @month
and year(l.created) = @year
and l.refund = 0
group by c.category, v.vendorcode, p.productid, p.productcode, p.cost, l.cost, t.productlastlead, t.totalleads, p.newcost, p.effectivedate
order by c.category, v.vendorcode, seq, t.productlastlead desc, t.totalleads desc, [noleads] desc, productcode

drop table #temp


go