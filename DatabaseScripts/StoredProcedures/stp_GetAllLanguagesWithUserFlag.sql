/****** Object:  StoredProcedure [dbo].[stp_GetAllLanguagesWithUserFlag]    Script Date: 11/19/2007 15:27:04 ******/
DROP PROCEDURE [dbo].[stp_GetAllLanguagesWithUserFlag]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[stp_GetAllLanguagesWithUserFlag]
	(
		@userid int
	)

as 


select
	tbllanguage.*,
	t.userid
from
	tbllanguage left outer join
	(
		select
			*
		from
			tbluserlanguage
		where
			userid = @userid
	)
	as t on tbllanguage.languageid = t.languageid
order by
	tbllanguage.name
GO
