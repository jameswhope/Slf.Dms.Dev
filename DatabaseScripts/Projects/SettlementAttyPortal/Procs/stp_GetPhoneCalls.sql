/****** Object:  StoredProcedure [dbo].[stp_GetPhoneCalls]    Script Date: 11/19/2007 15:27:13 ******/
DROP PROCEDURE [dbo].[stp_GetPhoneCalls]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetPhoneCalls]
	(
		@returntop varchar (50) = '100 percent',
		@where varchar (8000) = '',
		@orderby varchar (8000) = '',
		@userid int
	)

as

declare @clientjoin varchar(1000)
	
-- filter search results if user belongs to specific company(s)
if exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	set @clientjoin = ' join tblclient on tblclient.clientid = tblperson.clientid
						join tblusercompanyaccess uc on uc.companyid = tblclient.companyid and uc.userid = ' + cast(@userid as varchar(10))
end else
	set @clientjoin = ' left outer join tblclient on tblclient.clientid = tblperson.clientid'


exec
(
	'select top ' + @returntop + '
		tblphonecall.*,
		tblperson.firstname as personfirstname,
		tblperson.lastname as personlastname,
		tbluser.firstname as userfirstname,
		tbluser.lastname as userlastname,
		tblclient.clientid,
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedbyname,
		ut.name as usertype
	from
		tblphonecall left outer join
		tblperson on tblphonecall.personid = tblperson.personid '
		+ @clientjoin + ' left outer join
		tbluser on tblphonecall.userid = tbluser.userid left outer join
		tbluser as tblcreatedby on tblphonecall.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on tblphonecall.lastmodifiedby = tbllastmodifiedby.userid left outer join
		tblusertype ut on tbluser.usertypeid=ut.usertypeid
	' + @where + ' ' + @orderby
)
GO
