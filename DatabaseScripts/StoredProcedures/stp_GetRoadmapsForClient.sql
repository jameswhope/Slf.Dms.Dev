/****** Object:  StoredProcedure [dbo].[stp_GetRoadmapsForClient]    Script Date: 11/19/2007 15:27:16 ******/
DROP PROCEDURE [dbo].[stp_GetRoadmapsForClient]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_GetRoadmapsForClient]
	(
		@clientid int
	)

as

select
	tblclientstatus.parentclientstatusid,
	tblclientstatus.[name] as clientstatusname,
	tblroadmap.*,
	tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname,
	tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname as lastmodifiedbyname
from
	tblroadmap inner join
	tblclientstatus on tblroadmap.clientstatusid = tblclientstatus.clientstatusid left outer join
	tbluser as tblcreatedby on tblroadmap.createdby = tblcreatedby.userid left outer join
	tbluser as tbllastmodifiedby on tblroadmap.lastmodifiedby = tbllastmodifiedby.userid
where
	tblroadmap.clientid = @clientid
order by
	tblroadmap.created
GO
