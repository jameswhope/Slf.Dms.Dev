/****** Object:  StoredProcedure [dbo].[stp_GetAllPositionsWithUserFlag]    Script Date: 11/19/2007 15:27:04 ******/
DROP PROCEDURE [dbo].[stp_GetAllPositionsWithUserFlag]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_GetAllPositionsWithUserFlag]
	(
		@userid int
	)

as 


select
	tblposition.*,
	t.userid
from
	tblposition left outer join
	(
		select
			*
		from
			tbluserposition
		where
			userid = @userid
	)
	as t on tblposition.positionid = t.positionid
order by
	tblposition.name
GO
