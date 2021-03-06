/****** Object:  StoredProcedure [dbo].[stp_GetClientsForTask]    Script Date: 11/19/2007 15:27:05 ******/
DROP PROCEDURE [dbo].[stp_GetClientsForTask]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[stp_GetClientsForTask]
	(
		@taskid int
	)

as


select
	tblclient.*,
	tblperson.firstname + ' ' + tblperson.lastname as primarypersonname,
	tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname,
	tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname as lastmodifiedbyname
from
	tblclient inner join
	tblperson on tblclient.primarypersonid = tblperson.personid inner join
	tblclienttask on tblclient.clientid = tblclienttask.clientid left outer join
	tbluser as tblcreatedby on tblclient.createdby = tblcreatedby.userid left outer join
	tbluser as tbllastmodifiedby on tblclient.lastmodifiedby = tbllastmodifiedby.userid
where
	tblclienttask.taskid = @taskid
GO
