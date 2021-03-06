/****** Object:  StoredProcedure [dbo].[stp_GetDocFoldersForFolder]    Script Date: 11/19/2007 15:27:08 ******/
DROP PROCEDURE [dbo].[stp_GetDocFoldersForFolder]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_GetDocFoldersForFolder]
	(
		@parentdocfolderid int
	)

as


select
	tbldocfolder.*,
	tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname,
	tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname as lastmodifiedbyname
from
	tbldocfolder left outer join
	tbluser as tblcreatedby on tbldocfolder.createdby = tblcreatedby.userid left outer join
	tbluser as tbllastmodifiedby on tbldocfolder.lastmodifiedby = tbllastmodifiedby.userid
where
	tbldocfolder.parentdocfolderid = @parentdocfolderid
order by
	tbldocfolder.[name]
GO
