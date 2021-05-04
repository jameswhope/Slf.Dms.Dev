if exists (select 1 from sysobjects where name = 'stp_enrollment_selfGenInternetProducts')
	drop procedure stp_enrollment_selfGenInternetProducts
go

create procedure stp_enrollment_selfGenInternetProducts
(
	@date datetime
)
as

declare @month int, @year int

set @month = month(@date)
set @year = year(@date)


select 
	isnull(ov.vendorcode,v.vendorcode) [vendorcode], 
	-1 [productid], 
	'Default Cost' [productcode], 
	v.defaultcost [currentcost], 
	0 [revshare],
	v.defaultcost [cost], 
	count(*) [noleads], 
	sum(l.cost) [spent],
	min(l.created) [firstlead],
	max(l.created)[lastlead],
	0 [seq],
	0 [newcost], 
	'1/1/1900' [effectivedate]
from tblleadapplicant l
join tblleadproducts p  on p.productid = l.productid 
join tblleadvendors v on v.vendorid = p.vendorid 
left join tblleadproducts o on o.productid = l.origproductid
left join tblleadvendors ov on ov.vendorid = o.vendorid
where 1=1
	and month(l.created) = @month
	and year(l.created) = @year
	and l.refund = 0
	and isnull(ov.categoryid,v.categoryid) = 101
group by isnull(ov.vendorcode,v.vendorcode), v.defaultcost

union all

select 
	isnull(ov.vendorcode,v.vendorcode) [vendorcode], 
	isnull(o.productid,p.productid) [productid], 
	isnull(o.productcode,p.productcode) [productcode], 
	isnull(o.cost,p.cost) [currentcost], 
	isnull(o.revshare,p.revshare) [revshare],
	l.cost, 
	count(distinct l.leadapplicantid) [noleads],
	sum(l.cost) [spent],
	min(l.created) [firstlead],
	max(l.created) [lastlead],
	1 [seq],
	case when month(getdate()) = @month and year(getdate()) = @year then isnull(p.newcost,0) else 0 end [newcost],
	case when month(getdate()) = @month and year(getdate()) = @year then isnull(p.effectivedate,'1/1/1900') else '1/1/1900' end [effectivedate]
from tblleadapplicant l 
join tblleadproducts p on p.productid = l.productid 
join tblleadvendors v on v.vendorid = p.vendorid 
left join tblleadproducts o on o.productid = l.origproductid
left join tblleadvendors ov on ov.vendorid = o.vendorid
where 1=1
	and month(l.created) = @month
	and year(l.created) = @year
	and l.refund = 0
	and isnull(ov.categoryid,v.categoryid) = 101
group by isnull(ov.vendorcode,v.vendorcode), isnull(o.productid,p.productid), isnull(o.productcode,p.productcode), isnull(o.cost,p.cost), isnull(o.revshare,p.revshare), 
	l.cost, p.newcost, p.effectivedate

order by v.vendorcode, seq, productcode



go