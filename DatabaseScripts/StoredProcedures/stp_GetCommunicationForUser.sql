/****** Object:  StoredProcedure [dbo].[stp_GetCommunicationForUser]    Script Date: 11/19/2007 15:27:07 ******/
DROP PROCEDURE [dbo].[stp_GetCommunicationForUser]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetCommunicationForUser]
	(
		@returntop varchar (50) = '100 percent',
		@userid int,
		@shortvalue int = 150
	)

as


exec
(
	'select
		''Note'' as type,
		t.lastmodified as [date],
		tblclient.clientid,
		tblperson.firstname + '' '' + tblperson.lastname as [client],
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as [by],
		t.[value] as message,
		substring(t.[value], 0, ' + @shortvalue + ') + ''...'' as shortmessage,
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedby,
		t.noteid
	from
		(
		select top ' + @returntop + '
			*
		from
			tblnote
		where
			(tblnote.lastmodifiedby = ' + @userid + ')
		)
		as t inner join
		tblclient on t.clientid = tblclient.clientid inner join
		tblperson on tblclient.primarypersonid = tblperson.personid left outer join
		tbluser as tblcreatedby on t.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on t.lastmodifiedby = tbllastmodifiedby.userid
	order by
		t.noteid desc'
)
GO
