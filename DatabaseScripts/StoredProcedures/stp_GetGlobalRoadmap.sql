/****** Object:  StoredProcedure [dbo].[stp_GetGlobalRoadmap]    Script Date: 11/19/2007 15:27:09 ******/
DROP PROCEDURE [dbo].[stp_GetGlobalRoadmap]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetGlobalRoadmap]
	(
		@agencyId int=null,
		@attorneyId int=null
	)

as

declare @attorneystateid int
declare @attorneycompanyid int
--if not @attorneyid is null begin
--	set @attorneystateid=(select stateid from tblattorney where attorneyid=@attorneyid)
--	set @attorneycompanyid=(select companyid from tblattorney where attorneyid=@attorneyid)
--end


select 
	count(currentclientstatusid) as total,
	cs.parentclientstatusid,
	cs.clientstatusid,
	cs.name as clientstatusname,
	[order]
into 
	#tmp
from 
	tblclient c inner join
	tblclientstatus cs on c.currentclientstatusid=cs.clientstatusid inner join
	tblperson p on c.primarypersonid=p.personid
where 
	agencyid=isnull(@agencyid,agencyid)
	and (
		@attorneystateid is null or
		p.stateid=@attorneystateid
	)
	and (
		@attorneycompanyid is null or
		c.companyid=@attorneycompanyid
	)
group by
	currentclientstatusid,parentclientstatusid,cs.[name],cs.clientstatusid,cs.[order]

select
	0 as total,
	parentclientstatusid,
	clientstatusid,
	name as clientstatusname,
	[order]
from
	tblclientstatus
where
	not clientstatusid in (select clientstatusid from #tmp)

union

select 
	total,
	parentclientstatusid,
	clientstatusid,
	clientstatusname,
	[order]
from 
	#tmp
order by
	[order],
	clientstatusid

drop table #tmp
GO
