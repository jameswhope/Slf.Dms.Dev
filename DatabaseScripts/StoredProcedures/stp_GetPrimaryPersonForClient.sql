/****** Object:  StoredProcedure [dbo].[stp_GetPrimaryPersonForClient]    Script Date: 11/19/2007 15:27:14 ******/
DROP PROCEDURE [dbo].[stp_GetPrimaryPersonForClient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetPrimaryPersonForClient]
	(
		@clientid int
	)

as

select
	tblperson.*,
	(case tblperson.relationship when 'prime' then 1 else 0 end) as isprime,
	tblstate.[name] as statename,
	tblstate.abbreviation as stateabbreviation,
	tbllanguage.[name] as languagename,
	tblclient.accountnumber,
	tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname,
	tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname as lastmodifiedbyname
from
	tblclient inner join
	tblperson on tblclient.primarypersonid = tblperson.personid inner join
	tblstate on tblperson.stateid = tblstate.stateid inner join
	tbllanguage on tblperson.languageid = tbllanguage.languageid left outer join
	tbluser as tblcreatedby on tblperson.createdby = tblcreatedby.userid left outer join
	tbluser as tbllastmodifiedby on tblperson.lastmodifiedby = tbllastmodifiedby.userid
where
	tblclient.clientid = @clientid and
	(case tblperson.relationship when 'prime' then 1 else 0 end) = 1
GO
