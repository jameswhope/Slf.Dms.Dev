/****** Object:  StoredProcedure [dbo].[stp_GetUserActivity]    Script Date: 11/19/2007 15:27:20 ******/
DROP PROCEDURE [dbo].[stp_GetUserActivity]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_GetUserActivity]
	(
		@returntop int = 30
	)

as


exec
(
	'select top ' + @returntop + '
		*
	from
		(
			select
				tblusersearch.userid,
				tbluser.username,
				''Searched For'' as type,
				null as typeid,
				tblusersearch.terms + '' ('' + convert(varchar(10), tblusersearch.results) + '')'' as activity,
				tblusersearch.search as [when]
			from
				tblusersearch inner join
				tbluser on tblusersearch.userid = tbluser.userid
			union
			select
				tbluservisit.userid,
				tbluser.username,
				''Visited '' + tbluservisit.type as type,
				tbluservisit.typeid,
				tbluservisit.display as activity,
				tbluservisit.visit as [when]
			from
				tbluservisit inner join
				tbluser on tbluservisit.userid = tbluser.userid
		)
		as derivedtbl
	order by
		[when] desc'
)
GO
