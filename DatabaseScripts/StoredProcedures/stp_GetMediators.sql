/****** Object:  StoredProcedure [dbo].[stp_GetMediators]    Script Date: 11/19/2007 15:27:10 ******/
DROP PROCEDURE [dbo].[stp_GetMediators]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetMediators]

as

select
	tbluser.*
from
	tbluser inner join
	tbluserposition on tbluser.userid = tbluserposition.userid
where
	tbluserposition.positionid = 4
order by
	tbluser.lastname, tbluser.firstname
GO
