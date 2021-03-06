/****** Object:  StoredProcedure [dbo].[stp_GetClientSearches]    Script Date: 11/19/2007 15:27:05 ******/
DROP PROCEDURE [dbo].[stp_GetClientSearches]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetClientSearches]
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
	set @join = ' join tblusercompanyaccess uc on uc.companyid = c.companyid and uc.userid = ' + cast(@userid as varchar(10))
end else
	set @join = ' '


exec
(
	'select top ' + @returntop + '
		tblclientsearch.*, cs.Name [ClientStatus]
	from
		tblclientsearch
	join 
		tblclient c on c.clientid = tblclientsearch.clientid
	join
		tblclientstatus cs on cs.clientstatusid = c.currentclientstatusid
	' + @join + ' ' + @where + ' ' + @orderby
)
GO
