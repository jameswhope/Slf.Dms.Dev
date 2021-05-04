IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetTrusts')
	BEGIN
		DROP  Procedure  stp_GetTrusts
	END

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
		ISNULL(tblState.Name, ''Virtual'') as statename,
		ISNULL(tblState.Abbreviation, ''VIRT'')  as stateabbreviation,
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedbyname
	from
		tbltrust left outer join
		tblstate on tbltrust.stateid = tblstate.stateid left outer join
		tbluser as tblcreatedby on tbltrust.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on tbltrust.lastmodifiedby = tbllastmodifiedby.userid '
	+ @where + ' ' + @orderby
)
