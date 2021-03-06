/****** Object:  StoredProcedure [dbo].[stp_Report_MediatorReassignment]    Script Date: 11/19/2007 15:27:39 ******/
DROP PROCEDURE [dbo].[stp_Report_MediatorReassignment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stp_Report_MediatorReassignment]
(
	@userid int
)

as

select
	c.clientid,
	p.firstname,
	p.lastname,
	p.ssn,
	c.accountnumber
from
	tblclient c inner join
	tblperson p on c.primarypersonid=p.personid
where
	c.assignedmediator=@userid
GO
