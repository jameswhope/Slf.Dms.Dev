IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_MarketingDashboard')
	BEGIN
		DROP  Procedure  stp_MarketingDashboard
	END

GO

create procedure [dbo].[stp_MarketingDashboard]
(
	@datefrom datetime = '1/1/2000', 
	@dateto datetime = '1/1/2050',
	@description varchar(50) = 'All',
	@vendorid int = null,
	@revshare bit = 0
)
as
begin

declare @ldatefrom datetime, @ldateto datetime, @ldescription varchar(50)

set @ldatefrom = @datefrom--'1/1/2010'
set @ldateto = @dateto--'2/20/2010 23:59'
set @ldescription = @description--'Today'


-- by description
select @ldescription [description],
	sum(case when l.refund = 0 then 1 else 0 end) [Total Leads],
	cast(sum(case when (g.groupname = 'Success' or l.reasonid = 24) and (p.revshare = 0 or l.cost > 0) and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when (g.groupname = 'Success' or l.reasonid = 24)	and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) as money) * 100 as varchar(30)) + '%</font>)' [Success],
	cast(sum(case when g.groupname = 'Failures'						and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Failures'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) as money) * 100 as varchar(30)) + '%</font>)' [Failures],
	cast(sum(case when g.groupname = 'No Contact'					and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'No Contact'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) as money) * 100 as varchar(30)) + '%</font>)' [No Contact],
	cast(sum(case when g.groupname = 'Bad Leads'					and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Bad Leads'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) as money) * 100 as varchar(30)) + '%</font>)' [Bad Leads],
	cast(sum(case when g.groupname = 'Pipeline'						and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Pipeline'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) as money) * 100 as varchar(30)) + '%</font>)' [Pipeline],
	cast(sum(case when g.groupname = 'New'							and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'New'							and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) as money) * 100 as varchar(30)) + '%</font>)' [New],
	cast(sum(case when g.groupname = 'Recycled'						and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Recycled'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) as money) * 100 as varchar(30)) + '%</font>)' [Recycled],
	sum(case when l.refund = 1 then 1 else 0 end) [Refunds]
from tblleadapplicant l with (nolock)
join tblleadstatus ls on ls.statusid = l.statusid
join tblleadstatusgroup g on g.statusgroupid = ls.statusgroupid
join tblleadproducts p on p.productid = l.productid
	and (@vendorid is null or p.vendorid = @vendorid)
where (l.created between @ldatefrom and @ldateto)
	and p.revshare = @revshare


-- by category
select @ldescription [description], isnull(c.category,'No Product ID')[category],
	sum(case when l.refund = 0 then 1 else 0 end) [Total Leads],
	cast(sum(case when (g.groupname = 'Success' or l.reasonid = 24) and (p.revshare = 0 or l.cost > 0) and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when (g.groupname = 'Success' or l.reasonid = 24)	and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Success],
	cast(sum(case when g.groupname = 'Failures'						and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Failures'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Failures],
	cast(sum(case when g.groupname = 'No Contact'					and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'No Contact'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [No Contact],
	cast(sum(case when g.groupname = 'Bad Leads'					and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Bad Leads'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Bad Leads],
	cast(sum(case when g.groupname = 'Pipeline'						and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Pipeline'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Pipeline],
	cast(sum(case when g.groupname = 'New'							and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'New'							and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [New],
	cast(sum(case when g.groupname = 'Recycled'						and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Recycled'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Recycled],
	sum(case when l.refund = 1 then 1 else 0 end) [Refunds]
from tblleadapplicant l with (nolock)
left join tblleadproducts p on p.productid = l.productid
left join tblleadvendors v on v.vendorid = p.vendorid
	and (@vendorid is null or p.vendorid = @vendorid)
left join tblleadcategories c on c.categoryid = v.categoryid
join tblleadstatus ls on ls.statusid = l.statusid
join tblleadstatusgroup g on g.statusgroupid = ls.statusgroupid
where (l.created between @ldatefrom and @ldateto)
	and p.revshare = @revshare
group by isnull(c.category,'No Product ID')
order by [category]


-- by vendor
select @ldescription [description], c.category, v.vendorcode,
	sum(case when l.refund = 0 then 1 else 0 end) [Total Leads],
	cast(sum(case when (g.groupname = 'Success' or l.reasonid = 24) and (p.revshare = 0 or l.cost > 0) and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when (g.groupname = 'Success' or l.reasonid = 24)	and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Success],
	cast(sum(case when g.groupname = 'Failures'						and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Failures'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Failures],
	cast(sum(case when g.groupname = 'No Contact'					and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'No Contact'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [No Contact],
	cast(sum(case when g.groupname = 'Bad Leads'					and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Bad Leads'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Bad Leads],
	cast(sum(case when g.groupname = 'Pipeline'						and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Pipeline'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Pipeline],
	cast(sum(case when g.groupname = 'New'							and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'New'							and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [New],
	cast(sum(case when g.groupname = 'Recycled'						and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Recycled'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Recycled],
	sum(case when l.refund = 1 then 1 else 0 end) [Refunds]
from tblleadapplicant l with (nolock)
join tblleadproducts p on p.productid = l.productid
join tblleadvendors v on v.vendorid = p.vendorid
	and (@vendorid is null or p.vendorid = @vendorid)
join tblleadcategories c on c.categoryid = v.categoryid
join tblleadstatus ls on ls.statusid = l.statusid
join tblleadstatusgroup g on g.statusgroupid = ls.statusgroupid
where (l.created between @ldatefrom and @ldateto)
	and p.revshare = @revshare
group by c.category, v.vendorcode
order by [category], [vendorcode]


-- by product
select @ldescription [description], c.category, v.vendorcode, p.productdesc,
	sum(case when l.refund = 0 then 1 else 0 end) [Total Leads],
	cast(sum(case when (g.groupname = 'Success' or l.reasonid = 24) and (p.revshare = 0 or l.cost > 0) and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when (g.groupname = 'Success' or l.reasonid = 24)	and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Success],
	cast(sum(case when g.groupname = 'Failures'						and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Failures'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Failures],
	cast(sum(case when g.groupname = 'No Contact'					and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'No Contact'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [No Contact],
	cast(sum(case when g.groupname = 'Bad Leads'					and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Bad Leads'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Bad Leads],
	cast(sum(case when g.groupname = 'Pipeline'						and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Pipeline'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Pipeline],
	cast(sum(case when g.groupname = 'New'							and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'New'							and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [New],
	cast(sum(case when g.groupname = 'Recycled'						and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Recycled'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Recycled],
	sum(case when l.refund = 1 then 1 else 0 end) [Refunds]
from tblleadapplicant l with (nolock)
join tblleadproducts p on p.productid = l.productid
join tblleadvendors v on v.vendorid = p.vendorid
	and (@vendorid is null or p.vendorid = @vendorid)
join tblleadcategories c on c.categoryid = v.categoryid
join tblleadstatus ls on ls.statusid = l.statusid
join tblleadstatusgroup g on g.statusgroupid = ls.statusgroupid
where (l.created between @ldatefrom and @ldateto)
	and p.revshare = @revshare
group by c.category, v.vendorcode, p.productdesc
order by [category], [vendorcode], [productdesc]


-- by affiliate
select @ldescription [description], c.category, v.vendorcode, p.productdesc, a.affiliatedesc,
	sum(case when l.refund = 0 then 1 else 0 end) [Total Leads],
	cast(sum(case when (g.groupname = 'Success' or l.reasonid = 24) and (p.revshare = 0 or l.cost > 0) and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when (g.groupname = 'Success' or l.reasonid = 24)	and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Success],
	cast(sum(case when g.groupname = 'Failures'						and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Failures'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Failures],
	cast(sum(case when g.groupname = 'No Contact'					and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'No Contact'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [No Contact],
	cast(sum(case when g.groupname = 'Bad Leads'					and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Bad Leads'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Bad Leads],
	cast(sum(case when g.groupname = 'Pipeline'						and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Pipeline'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Pipeline],
	cast(sum(case when g.groupname = 'New'							and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'New'							and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [New],
	cast(sum(case when g.groupname = 'Recycled'						and l.refund = 0 then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname = 'Recycled'						and l.refund = 0 then 1 else 0 end) / cast(sum(case when l.refund = 0 then 1 else 0 end) + .0001 as money) * 100 as varchar(30)) + '%</font>)' [Recycled],
	sum(case when l.refund = 1 then 1 else 0 end) [Refunds]
from tblleadapplicant l with (nolock)
join tblleadaffiliates a on a.affiliateid = l.affiliateid 
join tblleadproducts p on p.productid = a.productid
join tblleadvendors v on v.vendorid = p.vendorid
	and (@vendorid is null or p.vendorid = @vendorid)
join tblleadcategories c on c.categoryid = v.categoryid
join tblleadstatus ls on ls.statusid = l.statusid
join tblleadstatusgroup g on g.statusgroupid = ls.statusgroupid
where (l.created between @ldatefrom and @ldateto)
	and p.revshare = @revshare
group by c.category, v.vendorcode, p.productdesc, a.affiliatedesc
order by [category], [vendorcode], [productdesc], [Total Leads] desc, [affiliatedesc]



end 
go