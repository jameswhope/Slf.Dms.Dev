/****** Object:  StoredProcedure [dbo].[stp_GetEnrollmentForClient]    Script Date: 11/19/2007 15:27:09 ******/
DROP PROCEDURE [dbo].[stp_GetEnrollmentForClient]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stp_GetEnrollmentForClient]
	(
		@clientid int
	)

as

select
	tblenrollment.*,
	tblbehind.[name] as behindname,
	tblconcern.[name] as concernname,
	tblagency.[name] as agencyname,
	tblcompany.[name] as companyname
from
	tblenrollment left outer join
	tblbehind on tblenrollment.behindid = tblbehind.behindid left outer join
	tblconcern on tblenrollment.concernid = tblconcern.concernid left outer join
	tblagency on tblenrollment.agencyid = tblagency.agencyid left outer join
	tblcompany on tblenrollment.companyid = tblcompany.companyid
where
	tblenrollment.clientid = @clientid
GO
