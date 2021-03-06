/****** Object:  StoredProcedure [dbo].[stp_GetPersonPhonesForPerson]    Script Date: 11/19/2007 15:27:12 ******/
DROP PROCEDURE [dbo].[stp_GetPersonPhonesForPerson]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[stp_GetPersonPhonesForPerson]
	(
		@personid int
	)

as

select
	tblpersonphone.*,
	tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname,
	tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname as lastmodifiedbyname
from
	tblpersonphone left outer join
	tbluser as tblcreatedby on tblpersonphone.createdby = tblcreatedby.userid left outer join
	tbluser as tbllastmodifiedby on tblpersonphone.lastmodifiedby = tbllastmodifiedby.userid
where
	tblpersonphone.personid = @personid
GO
