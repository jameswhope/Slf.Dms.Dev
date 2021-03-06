/****** Object:  StoredProcedure [dbo].[stp_GetRoadmapForClient]    Script Date: 11/19/2007 15:27:16 ******/
DROP PROCEDURE [dbo].[stp_GetRoadmapForClient]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stp_GetRoadmapForClient]
	(
		@clientid int,
		@when datetime = null
	)

as

if @when is null
	begin
		set @when = getdate()
	end


select
top 1
	tblroadmap.*,
	tblclientstatus.[name]
from
	tblroadmap inner join
	tblclientstatus on tblroadmap.clientstatusid = tblclientstatus.clientstatusid
where
	tblroadmap.clientid = @clientid and
	not tblroadmap.created > @when
order by
	tblroadmap.created desc, tblroadmap.roadmapid desc
GO
