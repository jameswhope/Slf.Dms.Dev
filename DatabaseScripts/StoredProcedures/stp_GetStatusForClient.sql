/****** Object:  StoredProcedure [dbo].[stp_GetStatusForClient]    Script Date: 11/19/2007 15:27:17 ******/
DROP PROCEDURE [dbo].[stp_GetStatusForClient]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_GetStatusForClient]
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
