/****** Object:  StoredProcedure [dbo].[stp_GetNotesForTask]    Script Date: 11/19/2007 15:27:11 ******/
DROP PROCEDURE [dbo].[stp_GetNotesForTask]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetNotesForTask]
	(
		@taskid int
	)

as

select
	tbltasknote.tasknoteid,
	tbltasknote.taskid,
	tblnote.*,
	tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname,
	tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname as lastmodifiedbyname
from
	tblnote inner join
	tbltasknote on tblnote.noteid = tbltasknote.noteid left outer join
	tbluser as tblcreatedby on tblnote.createdby = tblcreatedby.userid left outer join
	tbluser as tbllastmodifiedby on tblnote.lastmodifiedby = tbllastmodifiedby.userid
where
	tbltasknote.taskid = @taskid
order by
	tblnote.created, tblnote.noteid
GO
