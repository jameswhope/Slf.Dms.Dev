/****** Object:  StoredProcedure [dbo].[stp_GetNotesForRoadmap]    Script Date: 11/19/2007 15:27:11 ******/
DROP PROCEDURE [dbo].[stp_GetNotesForRoadmap]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_GetNotesForRoadmap]
	(
		@roadmapid int
	)

as

select
	tblroadmapnote.roadmapnoteid,
	tblroadmapnote.roadmapid,
	tblnote.*,
	tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname,
	tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname as lastmodifiedbyname
from
	tblnote inner join
	tblroadmapnote on tblnote.noteid = tblroadmapnote.noteid left outer join
	tbluser as tblcreatedby on tblnote.createdby = tblcreatedby.userid left outer join
	tbluser as tbllastmodifiedby on tblnote.lastmodifiedby = tbllastmodifiedby.userid
where
	tblroadmapnote.roadmapid = @roadmapid
order by
	tblnote.created, tblnote.noteid
GO
