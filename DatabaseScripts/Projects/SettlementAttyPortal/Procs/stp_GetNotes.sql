/****** Object:  StoredProcedure [dbo].[stp_GetNotes]    Script Date: 11/19/2007 15:27:11 ******/
DROP PROCEDURE [dbo].[stp_GetNotes]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_GetNotes]
	(
		@returntop varchar (50) = '100 percent',
		@where varchar (8000) = '',
		@orderby varchar (8000) = '',
		@userid int
	)

as

declare @join varchar(2000)

-- filter search results if user belongs to specific company(s)
if exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	set @join = ' join tblclient c on c.clientid = tblnote.clientid
				  join tblusercompanyaccess uc on uc.companyid = c.companyid and uc.userid = ' + cast(@userid as varchar(10))
end else
	set @join = ' '


exec
(
	'select top ' + @returntop + '
		tblnote.*,
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedbyname
	from
		tblnote left outer join
		tbluser as tblcreatedby on tblnote.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on tblnote.lastmodifiedby = tbllastmodifiedby.userid
	' + @join + ' ' + @where + ' ' + @orderby
)
GO
