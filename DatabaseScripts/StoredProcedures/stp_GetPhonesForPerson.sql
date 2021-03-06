/****** Object:  StoredProcedure [dbo].[stp_GetPhonesForPerson]    Script Date: 11/19/2007 15:27:13 ******/
DROP PROCEDURE [dbo].[stp_GetPhonesForPerson]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_GetPhonesForPerson]
	(
		@personid int
	)

as

select
	tblpersonphone.personphoneid,
	tblphone.*,
	tblphonetype.[name] as phonetypename,
	tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname,
	tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname as lastmodifiedbyname
from
	tblphone inner join
	tblpersonphone on tblphone.phoneid = tblpersonphone.phoneid inner join
	tblphonetype on tblphone.phonetypeid = tblphonetype.phonetypeid left outer join
	tbluser as tblcreatedby on tblphone.createdby = tblcreatedby.userid left outer join
	tbluser as tbllastmodifiedby on tblphone.lastmodifiedby = tbllastmodifiedby.userid
where
	tblpersonphone.personid = @personid
order by
	tblphonetype.[name]
GO
