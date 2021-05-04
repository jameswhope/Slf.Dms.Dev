IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_MarketingDashboardExternalbyProduct')
	BEGIN
		DROP  Procedure  stp_MarketingDashboardExternalbyProduct
	END

GO

CREATE Procedure [stp_MarketingDashboardExternalbyProduct]
(
	@datefrom datetime = '1/1/2000', 
	@dateto datetime = '1/1/2050',
	@description varchar(50) = 'All',
	@vendorid int = null,
	@userid int
)
as
begin

declare @ldatefrom datetime, @ldateto datetime, @ldescription varchar(50), @agencyid int

select @agencyid = agencyid from tbluser where userid = @userid

set @ldatefrom = @datefrom--'1/1/2010'
set @ldateto = @dateto--'2/20/2010 23:59'
set @ldescription = @description--'Today'


-- by description
select @ldescription [description],
	count(l.leadapplicantid) [Total Leads],
	cast(sum(case when (g.groupname = 'Approved') and (p.revshare = 0 or l.cost > 0)  then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when (g.groupname = 'Approved')  then 1 else 0 end) / cast(count(l.leadapplicantid) as money) * 100 as varchar(30)) + '%</font>)' [Approved],
	cast(sum(case when g.groupname  = 'Pending'										  then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname  = 'Pending'	  then 1 else 0 end) / cast(count(l.leadapplicantid) as money) * 100 as varchar(30)) + '%</font>)' [Pending],
	cast(sum(case when g.groupname  = 'QNI'											  then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname  = 'QNI'	      then 1 else 0 end) / cast(count(l.leadapplicantid) as money) * 100 as varchar(30)) + '%</font>)' [QNI],
	cast(sum(case when g.groupname  = 'DNQ'										      then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname  = 'DNQ'	      then 1 else 0 end) / cast(count(l.leadapplicantid) as money) * 100 as varchar(30)) + '%</font>)' [DNQ],
	cast(sum(case when g.groupname  = 'Bad Leads'									  then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname  = 'Bad Leads'  then 1 else 0 end) / cast(count(l.leadapplicantid) as money) * 100 as varchar(30)) + '%</font>)' [Bad Leads],
	cast(sum(case when (g.groupname = 'Pipeline')									  then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when (g.groupname = 'Pipeline')  then 1 else 0 end) / cast(count(l.leadapplicantid) as money) * 100 as varchar(30)) + '%</font>)' [Pipeline],
	cast(sum(case when g.groupname  = 'New'											  then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname  = 'New'	 	  then 1 else 0 end) / cast(count(l.leadapplicantid) as money) * 100 as varchar(30)) + '%</font>)' [New],
	cast(sum(case when g.groupname  = 'No Contact'								      then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname  = 'No Contact' then 1 else 0 end) / cast(count(l.leadapplicantid) as money) * 100 as varchar(30)) + '%</font>)' [No Contact] 
from tblleadapplicant l with (nolock)
join tblleadstatus ls on ls.statusid = l.statusid
join tblleadstatusgroup g on g.statusgroupid = ls.statusgroupid
join tblleadproducts p on p.productid = l.productid and (@vendorid is null or p.vendorid = @vendorid)
join tblleadvendors v on v.vendorid = p.vendorid
where l.created between @ldatefrom and @ldateto
and (v.Internal = 0 or IsNull(@agencyid,-1) < 1) 
and (v.AgencyID = @agencyid or IsNull(@agencyid,-1) < 1)

-- by product
select @ldescription [description], p.productcode,
	count(l.leadapplicantid) [Total Leads],
	cast(sum(case when (g.groupname = 'Approved') and (p.revshare = 0 or l.cost > 0)  then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when (g.groupname = 'Approved')  then 1 else 0 end) / cast(count(l.leadapplicantid) as money) * 100 as varchar(30)) + '%</font>)' [Approved],
	cast(sum(case when g.groupname  = 'Pending'										  then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname  = 'Pending'	  then 1 else 0 end) / cast(count(l.leadapplicantid) as money) * 100 as varchar(30)) + '%</font>)' [Pending],
	cast(sum(case when g.groupname  = 'QNI'											  then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname  = 'QNI'	      then 1 else 0 end) / cast(count(l.leadapplicantid) as money) * 100 as varchar(30)) + '%</font>)' [QNI],
	cast(sum(case when g.groupname  = 'DNQ'										      then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname  = 'DNQ'	      then 1 else 0 end) / cast(count(l.leadapplicantid) as money) * 100 as varchar(30)) + '%</font>)' [DNQ],
	cast(sum(case when g.groupname  = 'Bad Leads'									  then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname  = 'Bad Leads'  then 1 else 0 end) / cast(count(l.leadapplicantid) as money) * 100 as varchar(30)) + '%</font>)' [Bad Leads],
	cast(sum(case when (g.groupname = 'Pipeline')									  then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when (g.groupname = 'Pipeline')  then 1 else 0 end) / cast(count(l.leadapplicantid) as money) * 100 as varchar(30)) + '%</font>)' [Pipeline],
	cast(sum(case when g.groupname  = 'New'											  then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname  = 'New'	 	  then 1 else 0 end) / cast(count(l.leadapplicantid) as money) * 100 as varchar(30)) + '%</font>)' [New],
	cast(sum(case when g.groupname  = 'No Contact'								      then 1 else 0 end) as varchar(10)) + ' (<font color=''blue''>' + cast(sum(case when g.groupname  = 'No Contact' then 1 else 0 end) / cast(count(l.leadapplicantid) as money) * 100 as varchar(30)) + '%</font>)' [No Contact] 
from tblleadapplicant l with (nolock)
join tblleadproducts p on p.productid = l.productid and (@vendorid is null or p.vendorid = @vendorid)
join tblleadvendors v on v.vendorid = p.vendorid 
join tblleadstatus ls on ls.statusid = l.statusid
join tblleadstatusgroup g on g.statusgroupid = ls.statusgroupid
where l.created between @ldatefrom and @ldateto
and (v.Internal = 0 or IsNull(@agencyid,-1) < 1) 
and (v.AgencyID = @agencyid or IsNull(@agencyid,-1) < 1)
group by p.productcode
order by p.productcode

end 
