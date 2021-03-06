/****** Object:  StoredProcedure [dbo].[stp_GetUsers]    Script Date: 11/19/2007 15:27:20 ******/
DROP PROCEDURE [dbo].[stp_GetUsers]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetUsers]
	(
		@returntop varchar (50) = '100 percent',
		@where varchar (8000) = '',
		@orderby varchar (8000) = ''
	)

as

if not @where=''
	set @where = ' WHERE ' + @where

if not @orderby=''
	set @orderby = ' ORDER BY ' + @orderby

exec
(
	'select top ' + @returntop + '
		tbluser.*,
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedbyname,
		tblusertype.name as usertypename,
		tblusergroup.name as usergroupname
	from
		tbluser left outer join
		tbluser as tblcreatedby on tbluser.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on tbluser.lastmodifiedby = tbllastmodifiedby.userid left outer join
		tblusertype on tbluser.usertypeid=tblusertype.usertypeid left outer join
		tblusergroup on tbluser.usergroupid=tblusergroup.usergroupid
	' + @where + ' ' + @orderby
)
GO
