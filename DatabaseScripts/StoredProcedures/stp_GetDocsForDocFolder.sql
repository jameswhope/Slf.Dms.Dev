/****** Object:  StoredProcedure [dbo].[stp_GetDocsForDocFolder]    Script Date: 11/19/2007 15:27:09 ******/
DROP PROCEDURE [dbo].[stp_GetDocsForDocFolder]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_GetDocsForDocFolder]
	(
		@docfolderid int
	)

as

select
	tbldoc.*,
	tbldocfolder.name as docfoldername,
	tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname,
	tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname as lastmodifiedbyname
from
	tbldoc inner join
	tbldocfolder on tbldoc.docfolderid = tbldocfolder.docfolderid left outer join
	tbluser as tblcreatedby on tbldoc.createdby = tblcreatedby.userid left outer join
	tbluser as tbllastmodifiedby on tbldoc.lastmodifiedby = tbllastmodifiedby.userid
where
	tbldoc.docfolderid = @docfolderid
order by
	tbldoc.[name]
GO
