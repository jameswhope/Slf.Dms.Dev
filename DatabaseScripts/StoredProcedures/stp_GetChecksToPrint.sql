/****** Object:  StoredProcedure [dbo].[stp_GetChecksToPrint]    Script Date: 11/19/2007 15:27:04 ******/
DROP PROCEDURE [dbo].[stp_GetChecksToPrint]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetChecksToPrint]
	(
		@where varchar (8000) = '',
		@orderby varchar (8000) = ''
	)

as


if not @orderby is null and not @orderby=''
	set @orderby=' order by ' + @orderby

exec
(
	'select
		tblchecktoprint.*,
		tblchecktoprint.firstname + '' '' + tblchecktoprint.lastname as ClientName,
		tblprintedby.firstname + '' '' + tblprintedby.lastname as printedbyname,
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname
	from
		tblchecktoprint left outer join
		tbluser as tblprintedby on tblchecktoprint.printedby = tblprintedby.userid left outer join
		tbluser as tblcreatedby on tblchecktoprint.createdby = tblcreatedby.userid '
	+ @where + ' ' + @orderby
)
GO
