/****** Object:  StoredProcedure [dbo].[stp_GetNextUserForClient]    Script Date: 11/19/2007 15:27:10 ******/
DROP PROCEDURE [dbo].[stp_GetNextUserForClient]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetNextUserForClient]
	(
		@languageid int,
		@positionid int
	)

as


select
	tbluser.userid,
	count(tblclient.clientid) as numclients
from
	tbluser	inner join
	tbluserlanguage on tbluser.userid = tbluserlanguage.userid inner join
	tbluserposition on tbluser.userid = tbluserposition.userid left outer join
	tblclient on tbluser.userid = tblclient.assignedunderwriter
where
	tbluserlanguage.languageid = @languageid and
	tbluserposition.positionid = @positionid
group by
	tbluser.userid
order by
	count(tblclient.clientid)
GO
