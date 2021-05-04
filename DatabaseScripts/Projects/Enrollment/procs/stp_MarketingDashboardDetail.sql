IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_MarketingDashboardDetail')
	BEGIN
		DROP  Procedure  stp_MarketingDashboardDetail
	END
GO

create procedure [dbo].[stp_MarketingDashboardDetail]
(
	@datefrom datetime, 
	@dateto datetime,
	@statusgroup varchar(30) = null,
	@category varchar(30) = null,
	@vendor varchar(30) = null,
	@productdesc varchar(50) = null,
	@affiliatecode varchar(30) = null
)
as
begin 

declare @refund bit, @reasonid int

if @statusgroup = 'Refund' begin
	set @refund = 1
	set @statusgroup = null
end
else 
	set @refund = 0
	
if @statusgroup = 'Success' 
	set @reasonid = 24


select l.rgrid, l.leadapplicantid, l.fullname, l.leadphone, l.email, p.productcode, a.affiliatecode, ls.description [status], r.description [reason],
	left(u.firstname,1) + '. ' + u.lastname [rep], l.remoteaddr, n.value [lastnote], m.callsmade, m.firstcallmade, l.created, cast(datediff(minute,l.created,m.firstcallmade) as varchar(10)) + 'min' [minutes]
from tblleadapplicant l 
join tblleadproducts p on p.productid = l.productid
join tblleadvendors v on v.vendorid = p.vendorid
join tblleadcategories c on c.categoryid = v.categoryid
join tblleadstatus ls on ls.statusid = l.statusid
join tblleadstatusgroup g on g.statusgroupid = ls.statusgroupid
left join tblleadaffiliates a on a.affiliateid = l.affiliateid
left join tbluser u on u.userid = l.repid
left join tblleadreasons r on r.leadreasonsid = l.reasonid
left join vw_enrollment_lastnotecreated vn on vn.leadapplicantid = l.leadapplicantid
left join tblleadnotes n on n.leadnoteid = vn.lastnoteid
left join vw_enrollment_callsmade m on m.leadapplicantid = l.leadapplicantid
where l.created between @datefrom and @dateto
and (@refund is null or l.refund = @refund)
and (@statusgroup is null or (g.groupname = @statusgroup or l.reasonid = @reasonid))
and (@category is null or c.category = @category)
and (@vendor is null or v.vendorcode = @vendor)
and (@productdesc is null or p.productdesc = @productdesc)
and (@affiliatecode is null or a.affiliatecode = @affiliatecode)
order by l.fullname


end
go