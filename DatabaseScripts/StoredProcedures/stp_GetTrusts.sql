/****** Object:  StoredProcedure [dbo].[stp_GetTrusts]    Script Date: 11/19/2007 15:27:19 ******/
DROP PROCEDURE [dbo].[stp_GetTrusts]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetTrusts]
	(
		@returntop varchar (50) = '100 percent',
		@where varchar (8000) = '',
		@orderby varchar (8000) = ''
	)

as


exec
(
	'select top ' + @returntop + '
		tbltrust.*,
		tblstate.[name] as statename,
		tblstate.abbreviation as stateabbreviation,
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedbyname
	from
		tbltrust inner join
		tblstate on tbltrust.stateid = tblstate.stateid left outer join
		tbluser as tblcreatedby on tbltrust.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on tbltrust.lastmodifiedby = tbllastmodifiedby.userid '
	+ @where + ' ' + @orderby
)
GO
