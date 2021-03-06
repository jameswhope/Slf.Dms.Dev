/****** Object:  StoredProcedure [dbo].[stp_GetCreditors]    Script Date: 11/19/2007 15:27:07 ******/
DROP PROCEDURE [dbo].[stp_GetCreditors]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetCreditors]
	(
		@return varchar (255) = '100 percent',
		@where varchar (8000) = '',
		@orderby varchar (8000) = ''
	)

as

exec
(
	'select top
		' + @return + '
		tblcreditor.*,
		tblstate.[name] as statename,
		tblstate.abbreviation as stateabbreviation,
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedbyname
	from
		tblcreditor left outer join
		tblstate on tblcreditor.stateid = tblstate.stateid left outer join
		tbluser as tblcreatedby on tblcreditor.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on tblcreditor.lastmodifiedby = tbllastmodifiedby.userid '
	+ @where + ' ' + @orderby
)
GO
