IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_MarketingDashboardDetailExternal')
	BEGIN
		DROP  Procedure  stp_MarketingDashboardDetailExternal
	END

GO

CREATE Procedure [stp_MarketingDashboardDetailExternal]
(
	@datefrom datetime, 
	@dateto datetime,
	@statusgroup varchar(30) = null,
	@vendor varchar(30) = null,
	@rep varchar(100) = null,
	@userid int
)
as
begin 

declare @agencyid int
	
select @agencyid = agencyid from tbluser where userid = @userid

select l.rgrid, l.leadapplicantid, l.fullname, l.leadphone, l.email, p.productcode, a.affiliatecode, ls.description [status], r.description [reason],
	left(u.firstname,1) + '. ' + u.lastname [rep], l.remoteaddr, n.value [lastnote], l.created, fd.firstdepositdate
from tblleadapplicant l 
join tblleadproducts p on p.productid = l.productid
join tblleadvendors v on v.vendorid = p.vendorid and v.internal = 0
join tblleadcategories c on c.categoryid = v.categoryid
join tblleadstatus ls on ls.statusid = l.statusid
join tblleadstatusgroup g on g.statusgroupid = ls.statusgroupid
left join tblleadaffiliates a on a.affiliateid = l.affiliateid
left join tbluser u on u.userid = l.repid
left join tblleadreasons r on r.leadreasonsid = l.reasonid
left join vw_enrollment_lastnotecreated vn on vn.leadapplicantid = l.leadapplicantid
left join tblleadnotes n on n.leadnoteid = vn.lastnoteid
left join vw_enrollement_firstdeposit fd on fd.leadapplicantid = l.leadapplicantid
where l.created between @datefrom and @dateto
and (@statusgroup is null or (g.groupname = @statusgroup))
and (@vendor is null or v.vendorcode = @vendor)
and (@rep is null or (isnull(u.firstname,'') + ' ' + isnull(u.lastname,'')) = @rep)
and (v.Internal = 0) 
and (v.AgencyID = @agencyid or IsNull(@agencyid,-1) < 1)
order by l.fullname


end
